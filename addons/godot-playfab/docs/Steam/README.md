# Steam integration

1. [Prerequisites](#prerequisites)
2. [Setup](#setup)
3. [API](#api)
4. [Example](#example)
5. [Example using **GodotSteam**](#example-using-godotsteam)

## Prerequisites

Before beginning, you should have:
- A PlayFab Title
- A Steam App Id
- A Steam Publisher Web API Key
    - Follow [Creating a Publisher Web API Key](https://partner.steamgames.com/doc/webapi_overview/auth#create_publisher_key) in the Steamworks documentation in order to generate it.

## Setup

To enable support for Steam authorization, PlayFab requires you to enable the Steam add-on.

1. Go to your Overview page of your PlayFab Title.
2. Select the **Add-ons** menu item.
3. In the list of available **Add-ons**, locate and select Steam

![Login Steam Setup 1](../images/login-steam-setup-1.png)

1. Click on the "Install Steam"
1. Enter your Steam Application ID
2. Enter your Steam Publisher Web API Key created earlier
3. Click on the "Install Steam" again

![Login Steam Setup 3](../images/login-steam-setup-2.png)

## Godot Steam Integration
If you want to use the Steam integration, please switch to the [`integrate-steam` branch](https://github.com/Structed/godot-playfab/tree/integrate-steam).
It holds an integration between godot-playfab and [GodotSteam](https://godotsteam.com/).

If you want to do a manual integration, please check the [Manual Setup](../Steam/manual-integration.md) documentation (not recommended).
However, it's a good read to understand how the Steam login works under the hood.


