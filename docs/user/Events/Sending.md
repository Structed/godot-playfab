# Sending Events

There are multiple ways of how you can write events:

* Batched Send
* Direct write

## Batched Send
should be used if you either want to:
* Save HTTP overhead traffic (by sending fewer individual event write requests)
* Ingest large numbers of events

PlayFab has API limits for # of requests and size of events.
Thus, it is **generally recommended** to batch events as much as possible to future-proof your game.

### Batching Defaults
However, `godot-playfab` sets defaults default on batch-sending to provide an easy to sue user experience for game developers.
You can change these defaults to fit your needs - see [Configuration](Configuration.md).


## Direct Write
should only be used if you:
* need to immediately send an event
* are sure you are not sending too many events

# API
The [PlayFabEvent](/addons/godot-playfab/PlayFabEvent.gd) Node class covers the PlayFab Event API.

Examples below assume:
```gdscript
var payload = {
    "foo": "bar"
}
var event_name = "title_player_event"
var callback = "_on_write_events_request_completed"
```

> :warning: **event_name** must be non-empty and contain only alphanumeric letters, dash(-), and underscore(_).

## Batched Send
> **Note**
>
> Events will be first batched, and only sent when:
> * a [configured Flush Threshold](Configuration.md) is met , or
> * the batch is [flushed manually](Flushing.md).
>
### Telemetry Event
Batch a Telemetry Event:
```gdscript
$PlayFabEvent.batch_title_player_telemetry_event(event_name, payload, Calable(self, callback))
```

### PlayStream Event
Batch a PlayStream Event:
```gdscript
$PlayFabEvent.batch_title_player_playstream_event(event_name, payload, Calable(self, callback))
```


## Direct Write

### Telemetry Event
Write a Telemetry Event:
````gdscript
$PlayFabEvent.write_title_player_telemetry_event(event_name, payload, Calable(self, callback))
````

### PlayStream Event
Write a PlayStream Event:
````gdscript
$PlayFabEvent.write_title_player_playstream_event(event_name, payload, Calable(self, callback))
````

Back: [Configuration for Events](Configuration.md) | Next: [Flushing Events](Flushing.md)
