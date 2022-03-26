# Flushing Events
Events will be automatically sent if either of the thresholds in the [Conifguration](./Configuration.md) is met.

However, you can also force flush the cache:


## Flush Telemetry Event Batch
````gdscript
$PlayFab._flush_telemetry_event_batch()
````

## Flush PlayStream Event Batch
````gdscript
$PlayFab._flush_playstream_event_batch()
````

Back: [Configuration for Events](Configuration.md) | Next: [Flushing Events](Flushing.md)