extends JsonSerializable
class_name LoginWithSteamRequest

# Unique identifier for the title, found in the Settings > Game Properties section of the PlayFab developer site when a title has been selected.
var TitleId: String

# Automatically create a PlayFab account if one is not currently linked to this ID.
var CreateAccount: bool

# The optional custom tags associated with the request (e.g. build number, external trace identifiers, etc.).
var CustomTags: Dictionary

# Base64 encoded body that is encrypted with the Title's public RSA key (Enterprise Only).
var EncryptedRequest: String

# Flags for which pieces of info to return for the user.
var InfoRequestParameters: GetPlayerCombinedInfoRequestParams

# Player secret that is used to verify API request signatures (Enterprise Only).
var PlayerSecret: String

# Authentication token for the user, returned as a byte array from Steam, and converted to a string (for example, the byte 0x08 should become "08").
var SteamTicket: String

# True if ticket was generated using ISteamUser::GetAuthTicketForWebAPI() using "AzurePlayFab" as the identity string. False if the ticket was generated with ISteamUser::GetAuthSessionTicket().
var TicketIsServiceSpecific: bool
