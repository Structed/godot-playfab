extends PlayFab
class_name PlayFabEvent, "res://addons/godot-playfab/icon.png"



## Emitted when the PlayStream Event batch was flushed
## @param event_ids: The IDs of the events written
signal event_batch_playstream_flushed(event_ids)

## Emitted when the Telemetry Event batch was flushed
## @param event_ids: The IDs of the events written
signal event_batch_telemetry_flushed(event_ids)


export(int) var event_batch_size = 5
export(int) var event_batch_timeout_seconds = 10


var playstream_event_batch = EventContentsCollection.new()
var telemetry_event_batch = EventContentsCollection.new()

func _ready():
	var timer = Timer.new()
	timer.process_mode = Timer.TIMER_PROCESS_IDLE
	timer.wait_time = event_batch_timeout_seconds
	timer.one_shot = false
	timer.autostart = true
	timer.connect("timeout", self, "_flush_playstream_event_batch")
	timer.connect("timeout", self, "_flush_telemetry_event_batch")
	add_child(timer)


func _process(_delta):
	check_event_batch_sizes()


func event_telemetry_write_events(request_data: WriteEventsRequest, callback: FuncRef):
	_post_with_entity_auth(request_data, "/Event/WriteTelemetryEvents", callback)


func event_playstream_write_events(request_data: WriteEventsRequest, callback: FuncRef):
	_post_with_entity_auth(request_data, "/Event/WriteEvents", callback)


# Directly write a Telemetry Event
func write_title_player_telemetry_event(event_name: String, payload: Dictionary, callback: FuncRef, event_namespace = "custom.%s" % _title_id):
	var event = assemble_event(event_name, payload, event_namespace)
	# We send a batch of events here!
	var request = WriteEventsRequest.new()
	request.Events.append(event)
	event_telemetry_write_events(request, callback)


# Directly write a PlayStream Event
func write_title_player_playstream_event(event_name: String, payload: Dictionary, callback: FuncRef, event_namespace = "custom.%s" % _title_id):
	var event = assemble_event(event_name, payload, event_namespace)
	# We send a batch of events here!
	var request = WriteEventsRequest.new()
	request.Events.append(event)
	event_playstream_write_events(request, callback)


func batch_title_player_telemetry_event(event_name: String, payload: Dictionary, callback: FuncRef, event_namespace = "custom.%s" % _title_id):
	var event = assemble_event(event_name, payload, event_namespace)
	telemetry_event_batch.append(event)


func batch_title_player_playstream_event(event_name: String, payload: Dictionary, callback: FuncRef, event_namespace = "custom.%s" % _title_id):
	var event = assemble_event(event_name, payload, event_namespace)
	playstream_event_batch.append(event)


func assemble_event(event_name: String, payload: Dictionary, callback: FuncRef, event_namespace = "custom.%s" % _title_id) -> EventContents:
	var event = EventContents.new()
	event.Name = event_name
	event.EventNamespace = event_namespace
	event.Payload = payload
	# Event can also have an Entity, which is a type/id combo.
	# If omitted, the event will be sent in the "current" Entity's context
	# Usually, this means `title_player_account`, as you are logged in with it in a client.

	return event


## Batch a PlayStream Event as master_player_account
## WILL NOT WORK IN A REGULAR CLIENT! As you only have a title_player_account token
func batch_master_player_playstream_event(event_name: String, payload: Dictionary, callback: FuncRef, event_namespace = "custom.%s" % _title_id):
	var event = EventContents.new()
	event.Name = event_name
	event.EventNamespace = event_namespace
	event.Payload = payload
	var entity = EntityKey.new()
	if _playfab_client_config.is_logged_in(): # Needed, also loads the config. If not logged in, willl use the current Entity
		entity.Id = _playfab_client_config.master_player_account_id
		entity.Type = EntityKey.ENTITY_TYPE_MASTER_PLAYER_ACCOUNT
		event.Entity = entity
	playstream_event_batch.append(event)


func check_event_batch_sizes():
	if playstream_event_batch.size() >= event_batch_size:
		_flush_playstream_event_batch()
	elif telemetry_event_batch.size() >= event_batch_size:
		_flush_telemetry_event_batch()


func _flush_playstream_event_batch():
	if playstream_event_batch.size() < 1:
		print_debug("No telemetry events to flush")
		return

	var request = WriteEventsRequest.new()
	request.Events = playstream_event_batch
	event_playstream_write_events(request, funcref(self, "_on_playstream_batch_flush"))
	playstream_event_batch.clear()
	print_debug("Flushed playstream batch")

func _flush_telemetry_event_batch():
	if telemetry_event_batch.size() < 1:
		print_debug("No playstream events to flush")
		return

	var request = WriteEventsRequest.new()
	request.Events = telemetry_event_batch
	event_telemetry_write_events(request, funcref(self, "_on_telemetry_batch_flush"))
	telemetry_event_batch.clear()
	print_debug("Flushed telemetry batch")


func _on_playstream_batch_flush(response: Dictionary):
	var event_ids: Array = response["data"]["AssignedEventIds"]
	print_debug("Flushed %s PlayStream events" % event_ids.size())
	emit_signal("event_batch_playstream_flushed", event_ids)


func _on_telemetry_batch_flush(response: Dictionary):
	var event_ids: Array = response["data"]["AssignedEventIds"]
	print_debug("Flushed %s Telemetry events" % event_ids.size())
	emit_signal("event_batch_telemetry_flushed", event_ids)
