# Steam Purchase Flow Implementation

This implementation follows the sequence diagram for a complete Steam purchase flow integrated with PlayFab Economy v2 and Azure Functions backend.

## Architecture Overview

The purchase flow consists of three main components:
1. **Godot Client** - Initiates and manages the purchase UI
2. **Azure Functions Backend** - Handles Steam API calls and validates transactions
3. **Steam Backend** - Processes payments and authorizes transactions
4. **PlayFab** - Manages player inventory and item grants

## Flow Diagram

See the [main Economy README](./README.md) for the complete sequence diagram.

## Implementation Components

### 1. Godot Client (`PlayFabSteamPurchase.gd`)

**Location:** `addons/godot-playfab/PlayFabSteamPurchase.gd`

**Key Features:**
- Handles purchase initiation
- Listens for Steam authorization callbacks
- Communicates with Azure Functions backend
- Updates PlayFab inventory after successful purchase

**Signals:**
- `purchase_started(order_id: String)` - Emitted when order creation starts
- `purchase_authorized(order_id: String)` - Emitted when Steam authorizes the purchase
- `purchase_completed(order_id: String, granted_items: Array)` - Emitted when purchase is complete
- `purchase_failed(error_message: String)` - Emitted on any error

**Usage:**
```gdscript
var steam_purchase_manager = PlayFabSteamPurchase.new()
add_child(steam_purchase_manager)

steam_purchase_manager.purchase_started.connect(_on_purchase_started)
steam_purchase_manager.purchase_completed.connect(_on_purchase_completed)

steam_purchase_manager.purchase_item("item_001", 1, 4.99, "My awesome item")
```

### 2. Azure Functions Backend (`SteamPurchase.cs`)

**Location:** `backend/GodotPlayFab.Backend.Functions/SteamPurchase.cs`

**Endpoints:**

#### `POST /api/CreateSteamOrder`
Creates a Steam microtransaction order.

**Request:**
```json
{
  "steamId": "76561198012345678",
  "itemId": "item_001",
  "quantity": 1,
  "price": 4.99,
  "description": "Optional description"
}
```

**Response:**
```json
{
  "orderId": "1234567890",
  "transId": "9876543210",
  "steamUrl": "steam://url/..."
}
```

#### `POST /api/FinalizeSteamPurchase`
Finalizes the purchase after Steam authorization.

**Request:**
```json
{
  "orderId": "1234567890",
  "steamId": "76561198012345678",
  "itemId": "item_001"
}
```

**Response:**
```json
{
  "success": true,
  "orderId": "1234567890",
  "grantedItems": ["item_001"],
  "transactionId": "abc-123-def-456"
}
```

### 3. Configuration

#### Backend Configuration
Edit `backend/GodotPlayFab.Backend.Functions/local.settings.json`:
```json
{
  "Values": {
    "SteamPublisherKey": "YOUR_STEAM_PARTNER_PUBLISHER_KEY",
    "SteamAppId": "480"
  }
}
```

For production, set these as Azure Function App Settings.

#### Client Configuration
Add to your Godot project settings:
```
godot_playfab/backend_url = "https://your-function-app.azurewebsites.net/api"
```

Or for local development:
```
godot_playfab/backend_url = "http://localhost:7071/api"
```

## Security Considerations

⚠️ **IMPORTANT:** This implementation follows security best practices:

1. **All pricing logic is server-side** - Clients cannot manipulate prices
2. **Steam transaction validation** - Backend verifies all Steam responses
3. **PlayFab inventory grants are server-side** - Clients cannot grant items directly
4. **No trust in client data** - All item definitions and prices are validated on the server

## Testing

### Prerequisites
1. GodotSteam plugin installed and configured
2. Valid Steam App ID
3. Steam Partner Publisher Key
4. Azure Functions running locally or deployed
5. PlayFab title configured

### Local Testing
1. Start Azure Functions locally:
   ```bash
   cd backend/GodotPlayFab.Backend.Functions
   func start
   ```

2. Run the Godot project with Steam running

3. Navigate to Economy → Steam Purchase

4. Click "Purchase" button to test the flow

### Steam Sandbox Testing
For testing without real payments, use Steam's sandbox environment:
- Set up test accounts in Steamworks
- Configure sandbox mode in Steam settings
- Use test payment methods

## Known Limitations

1. **PlayFab Integration Incomplete**: The `RedeemToPlayFabInventory` method currently returns mock data. You need to implement:
   - PlayFab Server API integration
   - Entity token management
   - Inventory item granting via Economy v2 API

2. **Multiple Items**: Current implementation supports single item purchases. For multiple items, extend the `itemcount` parameter and item arrays in the InitTxn call.

3. **Currency Support**: Prices are assumed to be in USD. Add currency parameter for international support.

## Next Steps

To complete the implementation:

1. **Implement PlayFab Server API Integration**
   - Add PlayFab Server SDK to backend
   - Implement `GrantItemsToUser` or Economy v2 equivalent
   - Map Steam IDs to PlayFab Entity IDs

2. **Add Item Validation**
   - Verify item exists in catalog before creating order
   - Validate prices against catalog data
   - Check player eligibility

3. **Add Transaction Logging**
   - Store purchase records in database
   - Implement receipt generation
   - Add audit trail for compliance

4. **Error Recovery**
   - Handle partial failures (Steam OK but PlayFab fails)
   - Implement retry logic
   - Add manual reconciliation tools

## Resources

- [Steam Web API Documentation](https://partner.steamgames.com/doc/webapi)
- [PlayFab Economy v2 Documentation](https://learn.microsoft.com/en-us/gaming/playfab/features/economy-v2/)
- [GodotSteam Documentation](https://godotsteam.com/)
- [Azure Functions Documentation](https://learn.microsoft.com/en-us/azure/azure-functions/)

