# Connecting Signals
There are a few Signals that you can & should connect to:

| Signal Name       | Purpose                                                                                                                                              |
|-------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| api_error         | Emitted when a PlayFab API (HTTP status code 4xx) error occurs. Will receive a LoginResult as parameter.<br><br>Use to handle validation errors etc. |
| server_error      | Emitted when a Server Error (HTTP status code 5xx) occurs when querying PlayFab. Will receive the request path as parameter.                         |
| json_parse_error  | Emitted when the returned JSON could not be properly parsed. This should generally not be needed to be connected.                                    |
| registered        | Emitted when a new User is registered. You should only connect this in the Scene where you do Player Registrations.                                  |
| logged_in         | Emitted when a Player successfully logs in.                                                                                                          |

Back: [Basic Requests](basic-requests.md) | Next: [Events](Events/README.md)
