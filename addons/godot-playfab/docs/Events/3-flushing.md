# Flushing Events
Events will be automatically sent if either of the thresholds in the [Configuration](./Configuration.md) is met.

However, you can also force flush the cache:


## Flush Telemetry Event Batch
````gdscript
$PlayFab._flush_telemetry_event_batch()
````

## Flush PlayStream Event Batch
````gdscript
$PlayFab._flush_playstream_event_batch()
````

⬅️ [2 - Sending Events](2-sending.md) | [Events Overview](README.md) ⬆️
