# Login with Steam using [GodotSteam](https://godotsteam.com/)

## Summary

1. [Setup](#setup)
2. [Initialization](#initialization)
3. [Create Steam Auth Session Ticket](#create-steam-auth-session-ticket)
4. [Create Steam Auth Ticket For Web API](#create-steam-auth-ticket-for-web-api)
5. [Convert Steam Auth Ticket (Session and Web API)](#convert-steam-auth-ticket-session-and-web-api)
6. [PlayFab Login](#playFab-login)
7. [Cancel Steam Auth Ticket (Session and Web API)](#cancel-steam-auth-ticket-session-and-web-api)
8. [Altogether](#altogether)
9. [Troubleshooting](#troubleshooting)

---

## Setup

It exists many ways to install GodotSteam but for this example, we gonna used the GDExtension available for Godot 4.x.

> :warning: Be careful to install the normal extension and **not** the server extension

![Login Steam Godot Installation](/docs/images/login-steam-godot-installation.png)

---

## Initialization

When the game is run through the Steam client, it already knows which game you are playing. However, during development and testing, you must supply a valid app ID somehow. Typically, if you do not already have an app ID, you can use app ID 480 which is Valve's SpaceWar example game.
<br /><br />
There is three ways to set the app ID. For this example, we will used one of them. If you want to see the other, check [GodotSteam (Initializing Steam)](https://godotsteam.com/tutorials/initializing/).

```gdscript
func initialize_steam() -> bool:
    # Set steam environment only in editor because Steam know which game you are playing
    if OS.has_feature("editor"):
        OS.set_environment(STEAM_APP_ID_KEY, STEAM_APP_ID)
        OS.set_environment(STEAM_GAME_ID_KEY, STEAM_APP_ID)

    var result : Dictionary = Steam.steamInitEx(false) # Set to true if you want some local user's data
    if result.status > 0:
        print("Failure to initialize Steam with status %s" % result.status)
        return false
    return true
```

> :warning: Don't forget to replace **STEAM_APP_ID** by a valid String.

---

## Create Steam Auth Session Ticket

```gdscript
var steam_auth_ticket : Dictionary

func _ready() -> void:
    Steam.get_auth_session_ticket_response.connect(_on_get_auth_sesssion_ticket)

func create_auth_session_ticket() -> bool:
    auth_ticket = Steam.getAuthSessionTicket()
    return auth_ticket.size() > 0

func _on_get_auth_sesssion_ticket(auth_ticket_id: int, result: int) -> void:
    print("Auth Session Ticket (%s) return with result %s" % [auth_ticket_id, result])
```

---

## Create Steam Auth Ticket For Web API

```gdscript
var steam_auth_ticket : Dictionary

func _ready() -> void:
    Steam.get_ticket_for_web_api.connect(_on_get_auth_ticket_for_web_api_response)

func create_auth_ticket_for_web_api() -> void:
    Steam.getAuthTicketForWebApi("AzurePlayFab")

func _on_get_auth_ticket_for_web_api_response(auth_ticket: int, result: int, ticket_size: int, ticket_buffer: Array) -> void:
    print("Auth Ticker For Web API (%s) return with the result %s" % [auth_ticket, result])
    authTicketForWebAPI.id = auth_ticket
    authTicketForWebAPI.buffer = ticket_buffer
    authTicketForWebAPI.size = ticket_size
    getAuthTicketForWebAPICompleted.emit(result == 0)
```

---

## Convert Steam Auth Ticket (Session and Web API)

To login with Steam, PlayFab need a String as the Steam Auth Ticket. For that, we need to convert the buffer that we received before into an hexadecimal String.

```gdscript
func convert_auth_ticket() -> String:
	var ticket: String = ""
	for number in auth_ticket.buffer:
		ticket += "%02X" % number
	return ticket
```

---

## PlayFab Login

```gdscript
func _ready() -> void:
    PlayFabManager.client.logged_in.connect(_on_logged_in)
    PlayFabManager.client.api_error.connect(_on_api_error)
    PlayFabManager.client.server_error.connect(_on_server_error)

func login(ticket: String, is_auth_ticket_for_api: bool) -> void:
    var combined_info_request_params = GetPlayerCombinedInfoRequestParams.new()
    combined_info_request_params.show_all()
    var player_profile_view_constraints = PlayerProfileViewConstraints.new()
    combined_info_request_params.ProfileConstraints = player_profile_view_constraints
    PlayFabManager.client.login_with_steam(steam_auth_ticket, is_auth_ticket_for_api, true, combined_info_request_params)

func _on_logged_in(login_result: LoginResult) -> void:
    print("Playfab Login: %s" % login_result)

func _on_api_error(error_wrapper: ApiErrorWrapper) -> void:
    print("Playfab API Error: %s" % error_wrapper.errorMessage)

func _on_server_error(error_wrapper: ApiErrorWrapper) -> void:
    print("Playfab Server Error: %s" % error_wrapper.errorMessage)
```

---

## Cancel Steam Auth Ticket (Session and Web API)

Before continue, we have to cancel Steam auth ticket before leaving.

```gdscript
func cancel_auth_ticket() -> void:
	Steam.cancelAuthTicket(steam_auth_ticket.id)
```

---

## Altogether

```gdscript

```

---

## :warning: Troubleshooting

They are many possibles errors, the most commons are:
- Steam is not launched on your device
- Steam App Id is not correct
- Steam add-ons is not enabled in the PlayFab Title

If you still have an error, check the debugger, [GodotSteam (Initializing Steam)](https://godotsteam.com/tutorials/initializing/) or [GodoSteam (Authentication)](https://godotsteam.com/tutorials/authentication/).