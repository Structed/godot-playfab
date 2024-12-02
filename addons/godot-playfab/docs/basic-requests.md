# Basic Requests

## Overview
While `godot-playfab`'s aim is to provide convenient pre-built requests and models, we can likely never support the whole API surface.
Especially, when new APIs appear, `godot-playfab` will always lag a bit behind.

This requires the ability to write "generic" requests, where you can easily specify the path and request parameters and can parse the returned JSON by yourself.

## APIs
`godot-playfab` provides the following APIs to do generic requests:

| API Name                  | Description    |
|---------------------------|----------------|
| `PlayFab.post_dict_auth` | Takes a Dictionary as request body parameters. Will work on APIs that require authentication. You need to specify which Authentication type should be used (SessionTicket or EntityToken) |
| `PlayFab.post_dict`      | Takes a Dictionary as request body parameters. Will only work on APIs that do not require authentication. There is likely not a lot of reasons why you would need this method, as there are no requests that do not require authentication - except authentication calls. |

## Examples
### `PlayFab.post_dict_auth`

```gdscript
func GetTitleData():
    var dict = {
        "keys": [
            "BarKey"
        ]
    }

    PlayFabManager.client.post_dict_auth(dict,"/Client/GetTitleData", PlayFab.AUTH_TYPE.SESSION_TICKET, funcref(self, "_on_get_title_data"))

func _on_get_title_data(response):
    print_debug(JSON.print(response.data, "\t"))

```

Check out the [RequestBuilder.gd](/Scenes/RequestBuilder.gd) in the Scenes folder



Back: [Initial Setup](usage.md) | Next: [Connecting Signals](connecting-signals.md)
