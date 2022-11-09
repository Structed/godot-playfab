# Configuration for Events
When sending events, you may want to batch batch requests you send to save on API requests/open connections.

In order for you to be able to flexibly change those based on your needs wherever you are in your game, each `PlayFab` node exposes two settings:

| Name                | Variable                    | Description                                                                                       |
|---------------------|-----------------------------|---------------------------------------------------------------------------------------------------|
| Event Batch Size    | event_batch_size            | Determines how many events are batched before they are sent automatically                         |
| Event Batch Timeout | event_batch_timeout_seconds | Determines after how many seconds the batch will be flushed - disregarding the current batch size |
| Use Local Time      | use_local_time              | Defines whether local time is set on the event (true), or server time should be used (false)      |

## Considerations
> If your game crashes while having batched, unsent events, these will be lost!

> If you use multiple `PlayFab` nodes, you may set these values independently

Suppose you want to implement a logger of which sends Telemetry Events for debugging purposes. But you would also like to write general PlayStream events to react upon.
You could then configure two different `PlayFab` objects with different batching configurations.

### Example:
#### Logger
Log Telemetry Events immediately

| Name                | Value        |
|---------------------|--------------|
| Event Batch Size    | 1            |
| Event Batch Timeout | 10 (default) |

#### PlayStream Events
Sending small PlayStream events, we don't really care when/if they are being sent

| Name                | Value        |
|---------------------|--------------|
| Event Batch Size    | 5 (default)  |
| Event Batch Timeout | 10 (default) |

Back: [Events - PlayStream & Telemetry](README.md) | Next: [Sending Events](Sending.md)
