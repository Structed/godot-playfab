@icon("res://addons/godot-playfab/icon.png")

extends PlayFab
class_name PlayFabEvent


# Emitted when the PlayStream Event batch was flushed
# @param event_ids: The IDs of the events written
signal event_batch_playstream_flushed(event_ids)

# Emitted when the Telemetry Event batch was flushed
# @param event_ids: The IDs of the events written
signal event_batch_telemetry_flushed(event_ids)

# Defines the event batch size threshold
@export var event_batch_size: int = 5

# Defines the wait time (in seconds) until batches are flushed
@export var event_batch_timeout_seconds: int = 10

# Defines whether local time is set checked the event (true),
# or server time should be used (false)
@export var use_local_time: bool = true


var playstream_event_batch = EventContentsCollection.new()
var telemetry_event_batch = EventContentsCollection.new()

func _ready():
	super._ready()
	
	var timer = Timer.new()
	timer.process_mode = Timer.TIMER_PROCESS_IDLE
	timer.wait_time = event_batch_timeout_seconds
	timer.one_shot = false
	timer.autostart = true
	timer.connect("timeout",Callable(self,"_flush_playstream_event_batch"))
	timer.connect("timeout",Callable(self,"_flush_telemetry_event_batch"))
	add_child(timer)


func _process(_delta):
	_flush_batches_on_batch_size_met()


# Write batches of entity based events to as Telemetry events (bypass PlayStream).
# Prefer using `batch_title_player_telemetry_event`
# @Visibility: Public
# @param request_data: WriteEventsRequest - Request object, holidng multiple requests.
# @callback: Callable (optional) - Optjonal callback function, receiving a Dictionary with the returned Event ID.
func event_telemetry_write_events(request_data: WriteEventsRequest, callback: Callable = func():):
	_post_with_entity_auth(request_data, "/Event/WriteTelemetryEvents", callback)


# Write batches of entity based events to PlayStream.
# Prefer using `batch_title_player_playstream_event`
# @Visibility: Public
# @param request_data: WriteEventsRequest - Request object, holidng multiple requests.
# @callback: Callable (optional) - Optjonal callback function, receiving a Dictionary with the returned Event ID.
func event_playstream_write_events(request_data: WriteEventsRequest, callback: Callable = func():):
	_post_with_entity_auth(request_data, "/Event/WriteEvents", callback)


# Directly write a Telemetry Event
# @Visibility: Public
# @param event_name: String - The Event's name
# @param payload: Dictionary - A dictionary to send as event payload
# @param callback: Callable (optional) - A callback, providing a Dictionary containing the Event ID.
# @param event_namespace: String (optional) - The namespace of the Event must be 'custom' or start with 'custom.'.
func write_title_player_telemetry_event(event_name: String, payload: Dictionary, callback: Callable = func():, event_namespace = "custom.%s" % _title_id):
	var event = _assemble_event(event_name, payload, event_namespace)
	# We send a batch of events here!
	var request = WriteEventsRequest.new()
	request.Events.append(event)
	event_telemetry_write_events(request, callback)


# Directly write a PlayStream Event
# @Visibility: Public
# @param event_name: String - The Event's name
# @param payload: Dictionary - A dictionary to send as event payload
# @param callback: Callable (optional) - A callback, providing a Dictionary containing the Event ID.
# @param event_namespace: String (optional) - The namespace of the Event must be 'custom' or start with 'custom.'.
func write_title_player_playstream_event(event_name: String, payload: Dictionary, callback: Callable = func():, event_namespace = "custom.%s" % _title_id):
	var event = _assemble_event(event_name, payload, event_namespace)
	# We send a batch of events here!
	var request = WriteEventsRequest.new()
	request.Events.append(event)
	event_playstream_write_events(request, callback)


# Batch a Telemetry Event for later sending
# @Visibility: Public
# @param event_name: String - The Event's name
# @param payload: Dictionary - A dictionary to send as event payload
# @param callback: Callable (optional) - A callback, providing a Dictionary containing the Event ID.
# @param event_namespace: String (optional) - The namespace of the Event must be 'custom' or start with 'custom.'.
func batch_title_player_telemetry_event(event_name: String, payload: Dictionary, callback: Callable = func():, event_namespace = "custom.%s" % _title_id):
	var event = _assemble_event(event_name, payload, event_namespace)
	telemetry_event_batch.append(event)


# Batch a PlayStream Event for later sending
# @Visibility: Public
# @param event_name: String - The Event's name
# @param payload: Dictionary - A dictionary to send as event payload
# @param callback: Callable (optional) - A callback, providing a Dictionary containing the Event ID.
# @param event_namespace: String (optional) - The namespace of the Event must be 'custom' or start with 'custom.'.
func batch_title_player_playstream_event(event_name: String, payload: Dictionary, callback: Callable = func():, event_namespace = "custom.%s" % _title_id):
	var event = _assemble_event(event_name, payload, event_namespace)
	playstream_event_batch.append(event)

# Assembles event data
# @Visibility: Private
# @Visibility: Public
# @param event_name: String - The Event's name
# @param payload: Dictionary - A dictionary to send as event payload
# @param callback: Callable (optional) - A callback, providing a Dictionary containing the Event ID.
# @param event_namespace: String (optional) - The namespace of the Event must be 'custom' or start with 'custom.'.
func _assemble_event(event_name: String, payload: Dictionary, event_namespace = "custom.%s" % _title_id) -> EventContents:
	var event = EventContents.new()
	event.Name = event_name
	event.EventNamespace = event_namespace
	event.Payload = payload

	if use_local_time:
		event.OriginalTimestamp = Time.get_datetime_string_from_system(true) # Use UTC

	# Event can also have an Entity, which is a type/id combo.
	# If omitted, the event will be sent in the "current" Entity's context
	# Usually, this means `title_player_account`, as you are logged in with it in a client.

	return event


# Tiggers batch flush if comfigured treshold is met
# @Visibility: Private
func _flush_batches_on_batch_size_met():
	if playstream_event_batch.size() >= event_batch_size:
		_flush_playstream_event_batch()
	elif telemetry_event_batch.size() >= event_batch_size:
		_flush_telemetry_event_batch()

# Flushes the PlayStream event batch
# @Visibility: Private
func _flush_playstream_event_batch():
	if playstream_event_batch.size() < 1:
		print_debug("No telemetry events to flush")
		return

	var request = WriteEventsRequest.new()
	request.Events = playstream_event_batch
	event_playstream_write_events(request, Callable(self, "_on_playstream_batch_flush"))
	playstream_event_batch.clear()
	print_debug("Flushed playstream batch")


# Flushes the Telemetry event batch
# @Visibility: Private
func _flush_telemetry_event_batch():
	if telemetry_event_batch.size() < 1:
		print_debug("No playstream events to flush")
		return

	var request = WriteEventsRequest.new()
	request.Events = telemetry_event_batch
	event_telemetry_write_events(request, Callable(self, "_on_telemetry_batch_flush"))
	telemetry_event_batch.clear()
	print_debug("Flushed telemetry batch")


# Callback for after PlayStream batch flush
# @Visibility: Private
func _on_playstream_batch_flush(response: Dictionary):
	var event_ids: Array = response["data"]["AssignedEventIds"]
	print_debug("Flushed %s PlayStream events" % event_ids.size())
	emit_signal("event_batch_playstream_flushed", event_ids)


# Callback for after Telemetry batch flush
# @Visibility: Private
func _on_telemetry_batch_flush(response: Dictionary):
	var event_ids: Array = response["data"]["AssignedEventIds"]
	print_debug("Flushed %s Telemetry events" % event_ids.size())
	emit_signal("event_batch_telemetry_flushed", event_ids)
