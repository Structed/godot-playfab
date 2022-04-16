# Using `godot-playfab` in your Game
In any scene you want to use `godot-playfab`, just place a `PlayFabClient` node into your scene. When this is first used, it will create an encrypted `PlayFabConfig` file in `user://playfab_client_config.tres`. See the [File paths in Godot projects documentation](https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html).

This Config is used to store transient client data PlayFab needs to work across scenes, like the current PlayFab `Session Ticket`.

You can use an arbitrary number of `PlayFabClient` nodes. Each will get their configuration values from `PlayFabClientConfig` in the `PlayFabManager` singleton, which you should have already set up (see [Initial Setup](initial-setup.md))

# Working with Events
See [Events](Events/README.md)

Back: [Initial Setup](initial-setup.md) | Next: [Connecting Signals](connecting-signals.md)
