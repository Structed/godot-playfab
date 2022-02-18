extends JsonSerializable
class_name RegisterPlayFabUserRequest

# REQUIRED Unique identifier for the title, found in the Settings > Game Properties section of the PlayFab developer site when a title has been selected.
var TitleId: String

# The optional custom tags associated with the request (e.g. build number, external trace identifiers, etc.).
var CustomTags: Dictionary

# An optional parameter for setting the display name for this title (3-25 characters).
var DisplayName: String

# User email address attached to their account
var Email: String

# Base64 encoded body that is encrypted with the Title's public RSA key (Enterprise Only).
var EncryptedRequest: String

# Flags for which pieces of info to return for the user.
var InfoRequestParameters: GetPlayerCombinedInfoRequestParams

# Password for the PlayFab account (6-100 characters)
var Password: String

# Player secret that is used to verify API request signatures (Enterprise Only).
var PlayerSecret: String

# An optional parameter that specifies whether both the username and email parameters are required. If true, both parameters are required; if false, the user must supply either the username or email parameter. The default value is true.
var RequireBothUsernameAndEmail: bool

# PlayFab username for the account (3-20 characters)
var Username: String

