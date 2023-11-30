# Initial Setup
These steps only need to be done once:

## Downloading the addon
Grab the latest stable release from either the [Godot Asset Library](https://godotengine.org/asset-library/asset/1321) or [GitHub release](https://github.com/Structed/godot-playfab/releases).

> ⚠️ If you're using the AssetLib version:
>
> make sure to only select the `addons/godot-playfab` folder when importing the addon into your project.
> All the other files are only for development or examples and can/should therefore be ignored.

## Enabling the addon
* Copy the folder `/addons/godot-playfab` in your own project's `/addons/` directory
* In the `Plugins` tab of your Godot project's Project Settings, `"`godot-playfab`"` should now show up. Enable it.

If you close and re-open Project Settings, the General tab will now have a "PlayFab" option at the bottom of the left-hand sidebar.

## Setting the Title Id
* Go to [PlayFab](https://playfab.com), log in and copy your Title's ID
* In your Godot editor, open Project Settings
* Set the Title Id in `Playfab --> Title Id`

> ⚠️ If you cannot find the setting, just add it yourself!
> * Key: `playfab/title_id`
> * In the platform dropdown menu, select `(All)`
> * In the type dropdown menu, select `String`
> * Last, click the `Add` button
> After you added the setting, you can set the Title ID as described above.

Next: [Using `godot-playfab` in your Game](usage.md)

# Configuration
This is only for information. No action is required.
On autoload of the `PlayFabManager`, an encrypted `PlayFab Client Config` file will be created in `user://playfab_client_config.tres`.
See the [File paths in Godot projects documentation](https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html).

This Config is used to store transient client data PlayFab needs to work across scenes, like the current PlayFab `Session Ticket`.

# Example Project
Clone the full repo for a full example project where you can find out how different features are implemented and how you can make more sophisticated calls!

Back: [User Documentation](README.md) | Next: [Using `godot-playfab` in your Game](usage.md)
