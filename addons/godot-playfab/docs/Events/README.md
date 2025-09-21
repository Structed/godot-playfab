# Events

## Events Documentation Page Index
1. [Configuration](Configuration.md)
2. [Sending Events](Sending.md)
3. [Flushing Events](Flushing.md)

## PlayStream & Telemetry
> See the [Official Documentation](https://docs.microsoft.com/en-us/gaming/playfab/features/automation/playstream-events/)

PlayStream and Telemetry events are - from a integration perspective - the same.
The only difference when sending either event type is the different API name.

**The difference is in pricing!**

## TL;DR; - what should I use?
Telemetry Events - unless you need to react upon these events in near-real-time.
Telemetry Events are a lot less expensive!

## Differences
### PlayStream Events

PlayStream events...
* Near-real-time
* will appear in the GameStream
* can be reacted upon e.g.
    * execute script
    * send notification
    * give item etc.
* Can be worked with in the Data & Analytics features of PlayFab
* Cost **more than double** than Telemetry events!
* Otherwise have the same properties as Telemetry Events


### Telemetry Events
* Bypass the PlayStream
* Can be worked with in the Data & Analytics features of PlayFab

# Usage
Instead of (or in addition to any) `PlayFabClient` Nodes, drop a `PlayFabEvent` node in your scene!
You just need to make sure, a login was done before, so the EntityToken is available for Authentication

Back: [User Documentation](../README.md) | Next: [Configuration for Events](Configuration.md)
