# Initial Setup
These steps only need to be done once:

## Enabling the addon
* Copy the folder `/addons/godot-playfab` in your own project's `/addons/` directory
* Enable the addon in your project settings

Only now you will see a new setting: `Playfab --> Title ID`

## Setting the Title Id
* Go to [PlayFab](https://playfab.com), log in and copy your Title's ID
* In your Godot editor, open Project Settings
* Set the Title Id in `Playfab --> Title Id`

## Adding the `PlayFabManager` singleton AutoLoad
Add `res://addons/godot-playfab/PlayFabManager.gd` as Autoload with the Node Name `PlayFabManager` (should get prefilled like that)
> godot-playfab relies on the exact name `PlayFabManager`!

Back: [User Documentation](README.md) | Next: [Using `godot-playfab` in your Game](usage.md)
