extends Reference
class_name RegisterPlayFabUserResult

## Each account must have a unique email address in the PlayFab service. Once created, the account may be associated with additional accounts (Steam, Facebook, Game Center, etc.), allowing for added social network lists and achievements systems.

## If LoginTitlePlayerAccountEntity flag is set on the login request the title_player_account will also be logged in and returned.
var EntityToken: EntityTokenResponse

## PlayFab unique identifier for this newly created account.
var PlayFabId: String

## Unique token identifying the user and game at the server level, for the current session.
var SessionTicket: String

## Settings specific to this user.
var SettingsForUser#: UserSettings

## PlayFab unique user name.
var Username: String
