# GdUnit generated TestSuite
class_name PlayFabEventTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/godot-playfab/PlayFabEvent.gd'


func test__assemble_event_returns_event_with_properties_according_to_parameters() -> void:
	var playfab_event = auto_free(PlayFabEvent.new())
	var event_name = "my event name"
	var event_payload = {"foo" : "1" }
	var event_namespace = "my_event_namespace"
	
	var event = playfab_event._assemble_event(event_name, event_payload, event_namespace)
	
	var expected_event_contents = EventContents.new()
	expected_event_contents.Name = event_name
	expected_event_contents.Payload = event_payload
	expected_event_contents.EventNamespace = event_namespace

	assert_object(event).is_instanceof(EventContents)
	assert_str(event.Name).is_equal(expected_event_contents.Name)
	assert_dict(event.Payload).is_equal(expected_event_contents.Payload)
	assert_str(event.EventNamespace).is_equal(expected_event_contents.EventNamespace)


func test__batch_title_player_telemetry_event__does_not_add_more_than_maximum_events() -> void:
	var playfab_event: PlayFabEvent = auto_free(PlayFabEvent.new())
	for i in 205:
		playfab_event.batch_title_player_telemetry_event(str(i), {})
	
	assert_int(playfab_event.telemetry_event_batch.size()).is_less_equal(PlayFabEvent.max_batch_size)



func test__batch_title_player_playstream_event__does_not_add_more_than_maximum_events() -> void:
	var playfab_event: PlayFabEvent = auto_free(PlayFabEvent.new())
	for i in 205:
		playfab_event.batch_title_player_playstream_event(str(i), {})
	
	assert_int(playfab_event.playstream_event_batch.size()).is_less_equal(PlayFabEvent.max_batch_size)
