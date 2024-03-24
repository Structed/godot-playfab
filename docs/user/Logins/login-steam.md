# Login with Steam

## Summary

1. [Prerequisites](#prerequisites)
2. [Setup](#setup)
3. [API](#api)
4. [Examples](#examples)

---

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

## Examples

To call this method, you can use the [PlayFabManager](/addons/godot-playfab/PlayFabManager.gd) like below.

```gdscript
    PlayFabManager.client.login_with_steam(steam_auth_ticket, is_auth_ticket_for_api, create_account, info_request_parameter)
```

<br />

> :information_desk_person: A more advanced example using GodotSteam is also available [here](/docs/user/Logins/login-steam-godotsteam.md).
