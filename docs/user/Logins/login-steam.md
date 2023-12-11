# Login with Steam

## Prerequisites

Before beginning, you should have:
- A Playfab Title
- A Steam App Id
- A Steam Publish Web API Key
    - Follow [Creating a Publisher Web API Key](https://partner.steamgames.com/doc/webapi_overview/auth#create_publisher_key) in the Steamworkds documentation in order to generate it.

---

## Setup

To enable support for Steam authorization, PlayFab requires you to enable the Steam add-on.

1. Go to your Overview page of your Playfab Title.
2. Select the **Add-ons** menu item.
3. In the list of available **Add-ons**, locate and select Steam

![Login Steam Setup 1](/docs/images/login-steam-setup-1.png)

1. Click on the "Install Steam"
1. Enter your Steam Application ID
2. Enter your Steam Web API Key
3. Click on the "Install Steam" again
 
![Login Steam Setup 3](/docs/images/login-steam-setup-2.png)

---

## API

The [PlayFab](/addons/godot-playfab/PlayFab.gd) Node class implements the login with Steam using the method below.

```gdscript
    func login_with_steam(steam_auth_ticket: String, is_auth_ticket_for_api: bool, create_account: bool, info_request_parameters: GetPlayerCombinedInfoRequestParams) -> void:
```

- **steam_auth_ticket**: String that contains the steam authentification ticket in hexadecimal
- **is_auth_ticket_for_api**: True if the authentification ticket was generated for an API, false otherwise
- **create_account**: True if you want that it create a player account for your title
- **info_request_parameters**: Flags for which pièce of info to return for the user 

---

## Example

To call this method, you can use the [PlayFabManager](/addons/godot-playfab/PlayFabManager.gd) like below.

```gdscript
    PlayFabManager.client.login_with_steam(steam_auth_ticket, is_auth_ticket_for_api, create_account, info_request_parameter)
```

---

## Example using [GodotSteam](https://godotsteam.com/)

The code below works only with [GodotSteam](https://godotsteam.com/) (Extension that wraps [SteamSDK](https://partner.steamgames.com/downloads/list) for Godot).

![Login Steam Godot Installation](/docs/images/login-steam-godot-installation.png)

### Code

:warning: Don't forget to replace **YOUR_STEAM_APP_ID** by a valid String

```gdscript
    func _ready() -> void:
        _connect_to_signals()
    
        var authSessionTicket : String = _initialize_steam()
        if !authSessionTicket.is_empty():
            _login_with_steam(authSessionTicket)
    
    # Connect to PlayFab signals and Steam Authentification signal
    func _connect_to_signals() -> void:
        PlayFabManager.client.logged_in.connect(_on_logged_in)
        PlayFabManager.client.api_error.connect(_on_api_error)
        PlayFabManager.client.server_error.connect(_on_server_error)
        Steam.get_auth_session_ticket_response.connect(_on_get_auth_session_ticket_response)
    
    # Initialize Steam, retrieve a Steam authentification ticket and convert it into a String for PlayFab
    func _initialize_steam() -> String:
        # Remove OS.set_environement before exporting and shipping because Steam is already aware
        OS.set_environment("SteamAppId", YOUR_STEAM_APP_ID)
        OS.set_environment("SteamGameId", YOUR_STEAM_APP_ID)
    
        var init_response: Dictionary = Steam.steamInitEx(false)
        if init_response.status == 0:
            var authSessionTicket : Dictionary = Steam.getAuthSessionTicket()
    
            # Convert the buffer into a String with hexadecimal
            var steam_auth_ticket : String = ""
            for number in authSessionTicket.buffer:
                steam_auth_ticket += "%02X" % number # %X convert a number into hexadecimal with uppercase letters | 02 means two letters at least otherwise put 0
            return steam_auth_ticket
        else:
            printerr("Initialize Steam failed with response %s" % init_response)
            return ""
    
    # Create default parameters and login into PlayFab with Steam authentification ticket
    func _login_with_steam(steam_auth_ticket: String) -> void:
        var combined_info_request_params = GetPlayerCombinedInfoRequestParams.new()
        combined_info_request_params.show_all()
        var player_profile_view_constraints = PlayerProfileViewConstraints.new()
        combined_info_request_params.ProfileConstraints = player_profile_view_constraints
        PlayFabManager.client.login_with_steam(steam_auth_ticket, false, true, combined_info_request_params)
    
    func _on_logged_in(login_result: LoginResult) -> void:
        print("Playfab Login: " + str(login_result))
    
    func _on_api_error(error_wrapper: ApiErrorWrapper) -> void:
        print("Playfab API Error: " + error_wrapper.errorMessage)
    
    func _on_server_error(error_wrapper: ApiErrorWrapper) -> void:
        print("Playfab Server Error: " + error_wrapper.errorMessage)
    
    func _on_get_auth_session_ticket_response(this_auth_ticket: int, result: int) -> void:
        print("Auth Session Ticket (%s) return with result %s" % [this_auth_ticket, result])
```

### :warning: Troubleshooting

They are many possibles errors, the most commons are:
- Steam is not launched on your device
- Steam App Id is not correct
- Steam add-ons is not enabled in the PlayFab Title

If you still have an error, check the debugger or [GodotSteam (Initializing Steam)](https://godotsteam.com/tutorials/initializing/)
