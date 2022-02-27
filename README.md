![godot-playfab logo](addons/godot-playfab/icon.png)

# godot-playfab
is an [Azure PlayFab](https://playfab.com) addon for the [Godot Engine](https://godotengine.org/). While it is very early, it is supposed to be two things:

1. A GDscript-native SDK to Azure PlayFab
2. A Godot Editor integration to administer your game

## Motivation
I wanted to create an opinionated, "natural" Godot integration/SDK.
Anyone could use the C# SDK right now or use any SDK with GDnative. But these SDKs are only generated SDKs, with a lot of duplicated models, which are nothing more than an API wrapper. However, I wan it to feel natural to the environment of Godot.

So my plan is to not only create a GDScript-Native with more or less everything handcrafted,
but also use Godot's Signals and also provide in-editor tools to work with Godot.


## Demo
![Demo](demo-scene.gif)

You can use the included Demo scene setup in `Scenes` to see how `godot-playfab` can be used.

## Setup
### Enabling the addon
* Copy the folder `/addons/godot-playfab` in your own project's `/addons/` directory
* Enable the addon in your project settings

Only now you will see a new setting: `Playfab --> Title ID`

### Setting the Title Id
* Got to [PlayFab](https://playfab.com), log in and copy your Title's ID
* In your Godot editor, open Project Settings
* Set the Title Id in `Playfab --> Title Id`

### Using `godot-playfab` in your Game
First, you need to add a `PlayFab` node to your scene. When this is first used, it will create a `PlayFabConfig` file in `user://playfab_config.tres`. See the [File paths in Godot projects documentation](https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html).

This Config is used to store transient data PlayFab needs to work across scenes, like the current PlayFab `Session Ticket`.

#### Connecting Signals
There are a few Signals that you can connect to:

| Signal Name       | Purpose                                                                                                                                              |
|-------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| api_error         | Emitted when a PlayFab API (HTTP status code 4xx) error occurs. Will receive a LoginResult as parameter.<br><br>Use to handle validation errors etc. |
| server_error      | Emitted when a Server Error (HTTP status code 5xx) occurs when querying PlayFab. Will receive the request path as parameter.                         |
| json_parse_error  | Emitted when the returned JSON could not be properly parsed. This should generally not be needed to be connected.                                    |
| registered        | Emitted when a new User is registered. You should only connect this in the Scene where you do Player Registrations.                                  |
| logged_in         | Emitted when a Player successfully logs in.                                                                                                          |


## Maintainer Documentation

See [Maintainer Documentation](docs/README.md).
