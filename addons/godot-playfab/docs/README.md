# Feature Overview

`godot-playfab` is a Godot addon that provides easy access to the [PlayFab](https://playfab.com/)
Game Backend-as-a-Service (BaaS) platform for Godot Engine games/applications.





## Authentication
`godot-playfab` supports multiple authentication methods to log in users:

- **Anonymous Login**: Allows users to log in without any credentials.
- **Custom ID Login**: Users can log in using a custom identifier, with optional password.
- **Steam Login**: Integrates with Steam for user authentication.

It also takes care of some behind the scenes fundamentals:
- **Session Management**: Manages session tokens and handles re-authentication as needed.
- **Signal-Based Callbacks**: Signals for handling login success and failure.
- **Example Implementations**: The example project includes implementations for each login method.

## Events & Analytics
With the `PlayFabEvents` API, you can send telemetry and PlayStream events.
These events can be used in PlayFab's Data & Analytics features.

Events can be sent in two ways:
- **Batched Send**: To save cost/requests, Events are batched and sent when a configured threshold is met or manually flushed.
- **Direct Write**: Events are sent immediately, suitable for urgent events, mainly used for PlayStream events.

## Steam integration
godot-playfab has a built-in integration with [GodotSteam](https://godotsteam.com/).

> ⚠️ Steam integration is hosted on the [`integrate-steam`](https://github.com/Structed/godot-playfab/tree/integrate-steam) branch of the repository. Make sure to check it out if you want to use Steam login.
>
> You can easily enable Steam login in your game by following the steps in the [Steam integration](Steam/README.md) documentation.


## Example Project
If you clone the full repository, you get a full example project where you can find out how different features
are implemented.

You can absolutely use the example project as a starting point for your own game! In fact, I encourage you to do so!

Start with the default scene in `Scenes/Main.tscn` to see how to use `godot-playfab` in your game.

⬅️ [User Documentation](../README.md) | [Initial Setup](1-initial-setup.md) ➡️
