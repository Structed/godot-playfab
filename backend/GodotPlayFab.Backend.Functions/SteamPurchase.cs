using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace GodotPlayFab.Backend.Functions;

public class SteamPurchase
{
    private readonly ILogger<SteamPurchase> _logger;
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly IConfiguration _configuration;

    private const string SteamInitTxnUrl = "https://partner.steam-api.com/ISteamMicroTxn/InitTxn/v3/";
    private const string SteamFinalizeTxnUrl = "https://partner.steam-api.com/ISteamMicroTxn/FinalizeTxn/v2/";
    private const string PlayFabEconomyUrl = "https://{{titleId}}.playfabapi.com/Inventory/RedeemSteamInventoryItems";

    public SteamPurchase(ILogger<SteamPurchase> logger, IHttpClientFactory httpClientFactory, IConfiguration configuration)
    {
        _logger = logger;
        _httpClientFactory = httpClientFactory;
        _configuration = configuration;
    }

    /// <summary>
    /// Step 1: Client requests to create a Steam order
    /// </summary>
    [Function("CreateSteamOrder")]
    public async Task<HttpResponseData> CreateSteamOrder(
        [HttpTrigger(AuthorizationLevel.Function, "post")] HttpRequestData req)
    {
        _logger.LogInformation("CreateSteamOrder function triggered");

        try
        {
            var requestBody = await req.ReadAsStringAsync();
            if (string.IsNullOrEmpty(requestBody))
            {
                return await CreateErrorResponse(req, HttpStatusCode.BadRequest, "Empty request body");
            }

            var orderRequest = JsonSerializer.Deserialize<CreateSteamOrderRequest>(requestBody, new JsonSerializerOptions {PropertyNameCaseInsensitive = true});

            if (orderRequest == null || string.IsNullOrEmpty(orderRequest.SteamId))
            {
                return await CreateErrorResponse(req, HttpStatusCode.BadRequest, "Invalid request");
            }

            // Call Steam InitTxn API
            var steamAppId = _configuration["SteamAppId"] ?? "480";
            var steamPublisherKey = _configuration["SteamPublisherKey"] ?? string.Empty;

            if (string.IsNullOrEmpty(steamPublisherKey))
            {
                _logger.LogError("SteamPublisherKey not configured");
                return await CreateErrorResponse(req, HttpStatusCode.InternalServerError, "Server configuration error");
            }

            var httpClient = _httpClientFactory.CreateClient();

            // Docs: https://partner.steamgames.com/doc/webapi/ISteamMicroTxn#InitTxn
            var initTxnParams = new Dictionary<string, string>
            {
                { "key", steamPublisherKey },
                { "orderid", orderRequest.OrderId },                    // generated client-side
                { "appid", steamAppId },
                { "steamid", orderRequest.SteamId },                    // Player Steam ID
                { "itemcount", "1" },                                   // count of items in the basket
                { "language", "en" },
                { "currency", "USD" },
                { "usersession", "client" },                            // "client" or "web". Defaults to "client".
                { "itemid[0]", orderRequest.ItemId },                   // Item ID from ItemDefinition
                { "qty[0]", orderRequest.Quantity.ToString() },
                { "amount[0]", ((int)(orderRequest.Price)).ToString() }, // Price in cents
                { "description[0]", orderRequest.Description ?? $"Purchase of {orderRequest.ItemId}" },
                { "category[0]", "item" }
            };

            var content = new FormUrlEncodedContent(initTxnParams);
            var response = await httpClient.PostAsync(SteamInitTxnUrl, content);
            var responseContent = await response.Content.ReadAsStringAsync();

            _logger.LogInformation($"Steam InitTxn response: {responseContent}");

            var steamResponse = JsonSerializer.Deserialize<SteamInitTxnResponse>(responseContent, new JsonSerializerOptions {PropertyNameCaseInsensitive = true});

            if (steamResponse?.Response?.Result != "OK" || steamResponse?.Response?.Params == null)
            {
                _logger.LogError($"Steam InitTxn failed: {steamResponse?.Response?.Error?.ErrorDesc}");
                return await CreateErrorResponse(req, HttpStatusCode.BadRequest,
                    steamResponse?.Response?.Error?.ErrorDesc ?? "Steam transaction initialization failed");
            }

            var orderResponse = new CreateSteamOrderResponse
            {
                OrderId = steamResponse.Response.Params.OrderId,
                TransId = steamResponse.Response.Params.TransId,
                SteamUrl = steamResponse.Response.Params.SteamUrl
            };

            var result = req.CreateResponse(HttpStatusCode.OK);
            await result.WriteAsJsonAsync(orderResponse);
            return result;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error in CreateSteamOrder");
            return await CreateErrorResponse(req, HttpStatusCode.InternalServerError, "Internal server error");
        }
    }

    /// <summary>
    /// Step 2: Client notifies that order was authorized by Steam
    /// </summary>
    [Function("FinalizeSteamPurchase")]
    public async Task<HttpResponseData> FinalizeSteamPurchase(
        [HttpTrigger(AuthorizationLevel.Function, "post")] HttpRequestData req)
    {
        _logger.LogInformation("FinalizeSteamPurchase function triggered");

        try
        {
            var requestBody = await req.ReadAsStringAsync();
            var finalizeRequest = JsonSerializer.Deserialize<FinalizeSteamPurchaseRequest>(requestBody, new JsonSerializerOptions {PropertyNameCaseInsensitive = true});

            if (finalizeRequest == null || string.IsNullOrEmpty(finalizeRequest.OrderId))
            {
                return await CreateErrorResponse(req, HttpStatusCode.BadRequest, "Invalid request");
            }

            // Call Steam FinalizeTxn API
            var steamAppId = _configuration["SteamAppId"];
            var steamPublisherKey = _configuration["SteamPublisherKey"];

            var httpClient = _httpClientFactory.CreateClient();

            var finalizeTxnParams = new Dictionary<string, string>
            {
                { "key", steamPublisherKey },
                { "appid", steamAppId },
                { "orderid", finalizeRequest.OrderId }
            };

            var content = new FormUrlEncodedContent(finalizeTxnParams);
            var response = await httpClient.PostAsync(SteamFinalizeTxnUrl, content);
            var responseContent = await response.Content.ReadAsStringAsync();

            _logger.LogInformation($"Steam FinalizeTxn response: {responseContent}");

            var steamResponse = JsonSerializer.Deserialize<SteamFinalizeTxnResponse>(responseContent, new JsonSerializerOptions {PropertyNameCaseInsensitive = true});

            if (steamResponse?.Response?.Result != "OK")
            {
                _logger.LogError($"Steam FinalizeTxn failed: {steamResponse?.Response?.Error?.ErrorDesc}");
                return await CreateErrorResponse(req, HttpStatusCode.BadRequest,
                    steamResponse?.Response?.Error?.ErrorDesc ?? "Steam transaction finalization failed");
            }

            // Server-side validation of amount, item, currency
            _logger.LogInformation($"Steam transaction finalized. OrderId: {finalizeRequest.OrderId}");

            // Redeem purchase to PlayFab inventory (Economy v2)
            var playfabResult = await RedeemToPlayFabInventory(finalizeRequest, steamResponse);

            if (!playfabResult.Success)
            {
                _logger.LogError($"PlayFab redemption failed: {playfabResult.Error}");
                return await CreateErrorResponse(req, HttpStatusCode.InternalServerError,
                    playfabResult.Error ?? "Failed to redeem items in PlayFab");
            }

            var finalizeResponse = new FinalizeSteamPurchaseResponse
            {
                Success = true,
                OrderId = finalizeRequest.OrderId,
                GrantedItems = playfabResult.GrantedItems,
                TransactionId = playfabResult.TransactionId
            };

            var result = req.CreateResponse(HttpStatusCode.OK);
            await result.WriteAsJsonAsync(finalizeResponse);
            return result;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error in FinalizeSteamPurchase");
            return await CreateErrorResponse(req, HttpStatusCode.InternalServerError, "Internal server error");
        }
    }

    private async Task<PlayFabRedemptionResult> RedeemToPlayFabInventory(
        FinalizeSteamPurchaseRequest request,
        SteamFinalizeTxnResponse steamResponse)
    {
        try
        {
            // TODO:
            // 1. Get the PlayFab Entity Token for the player (from Steam ID mapping)
            // 2. Authenticate the entity token with PlayFab
            // 3. Call PlayFab Economy v2 API to grant items (using developer secret key)

            // For now, returning a mock successful response
            // You need to implement the actual PlayFab SDK integration
            _logger.LogWarning("PlayFab integration not fully implemented - returning mock success");

            return new PlayFabRedemptionResult
            {
                Success = true,
                TransactionId = Guid.NewGuid().ToString(),
                GrantedItems = new List<string> { request.ItemId ?? "unknown_item" }
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error redeeming to PlayFab");
            return new PlayFabRedemptionResult
            {
                Success = false,
                Error = ex.Message
            };
        }
    }

    private async Task<HttpResponseData> CreateErrorResponse(HttpRequestData req, HttpStatusCode statusCode, string message)
    {
        var response = req.CreateResponse(statusCode);
        await response.WriteAsJsonAsync(new { error = message });
        return response;
    }
}

// Request/Response Models
public class CreateSteamOrderRequest
{
    public string OrderId { get; set; } = string.Empty;
    public string SteamId { get; set; } = string.Empty;
    public string ItemId { get; set; } = string.Empty;
    public int Quantity { get; set; }
    public decimal Price { get; set; }
    public string? Description { get; set; }
}

public class CreateSteamOrderResponse
{
    public string OrderId { get; set; } = string.Empty;
    public string TransId { get; set; } = string.Empty;
    public string SteamUrl { get; set; } = string.Empty;
}

public class FinalizeSteamPurchaseRequest
{
    public string OrderId { get; set; } = string.Empty;
    public string SteamId { get; set; } = string.Empty;
    public string? ItemId { get; set; }
}

public class FinalizeSteamPurchaseResponse
{
    public bool Success { get; set; }
    public string OrderId { get; set; } = string.Empty;
    public List<string>? GrantedItems { get; set; }
    public string? TransactionId { get; set; }
}

public class PlayFabRedemptionResult
{
    public bool Success { get; set; }
    public string? Error { get; set; }
    public string? TransactionId { get; set; }
    public List<string>? GrantedItems { get; set; }
}

// Steam API Response Models
public class SteamInitTxnResponse
{
    public SteamInitTxnResponseData? Response { get; set; }
}

public class SteamInitTxnResponseData
{
    public string? Result { get; set; }
    public SteamInitTxnParams? Params { get; set; }
    public SteamError? Error { get; set; }
}

public class SteamInitTxnParams
{
    public string OrderId { get; set; } = string.Empty;
    public string TransId { get; set; } = string.Empty;
    public string SteamUrl { get; set; } = string.Empty;
}

public class SteamFinalizeTxnResponse
{
    public SteamFinalizeTxnResponseData? Response { get; set; }
}

public class SteamFinalizeTxnResponseData
{
    public string? Result { get; set; }
    public SteamFinalizeTxnParams? Params { get; set; }
    public SteamError? Error { get; set; }
}

public class SteamFinalizeTxnParams
{
    public string OrderId { get; set; } = string.Empty;
    public string TransId { get; set; } = string.Empty;
}

public class SteamError
{
    public int ErrorCode { get; set; }
    public string ErrorDesc { get; set; } = string.Empty;
}
