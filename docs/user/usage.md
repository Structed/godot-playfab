# Using `godot-playfab` in your Game

## In Code
> This is the preferred way of using `godot-playfab`!

Use the global `PlayFabManager.client` to call any PlayFab API.
Please have a look at the example Scenes on how it is being used.

## In the Editor
In any scene you want to use `godot-playfab`, just place a `PlayFabClient` node into your scene.

You can use an arbitrary number of `PlayFabClient` nodes. Each will get their configuration values from `PlayFabClientConfig` in the `PlayFabManager` singleton, which you should have already set up (see [Initial Setup](initial-setup.md))

# Working with Events
See [Events](Events/README.md)

Back: [Initial Setup](initial-setup.md) | Next: [Basic Requests](basic-requests.md)
