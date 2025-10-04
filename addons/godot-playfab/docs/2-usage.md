# Using `godot-playfab` in your Game

## In Code
> ℹ️ This is the preferred way of using `godot-playfab`!

* Use the global `PlayFabManager.client` to call the `/Client/` APIs - which is most of PlayFab's APIs.
* Use the global `PlayFabManager.event` to call [Event APIs](Events/README.md).
* For everything that's not covered, you can use "[basic requests](3-basic-requests.md)" to call any other APIs.

> ℹ️ Please have a look at the example Scenes on how these are being used.

## In the Editor
In any scene you want to use `godot-playfab`, just place a `PlayFabClient` node into your scene.

You can use an arbitrary number of `PlayFabClient` nodes. Each will get their configuration values from
`PlayFabClientConfig` in the `PlayFabManager` singleton, which you should have already set up
(see [Initial Setup](initial-setup.md))

## Authentication
Each of these clients can make their own requests, and each of those clients can do events in parallel.

They all use the same authentication state, so if you log in with one client, the other clients will also be authenticated. Authentication state is shared globally within `PlayFabClientConfig` and cached on disk in an encrypted format.

If you check `PlayFabClientConfig.is_logged_in` it will also check, if the session token is still valid for a good amount of time. It will return `false` if the session token is expired or about to expire, so you can then log in again.


⬅️ [1 - Initial Setup](1-initial-setup.md) | [3 - Basic Requests](3-basic-requests.md) ➡️
