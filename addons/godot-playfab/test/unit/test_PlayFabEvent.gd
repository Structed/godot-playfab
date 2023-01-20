extends "res://addons/gut/test.gd"


func before_each():
	gut.p("ran setup", 2)

func after_each():
	gut.p("ran teardown", 2)

func before_all():
	gut.p("ran run setup", 2)

func after_all():
	gut.p("ran run teardown", 2)

func test__assemble_event_returns_event_with_properties_according_to_parameters():
	var playfab_event = PlayFabEvent.new()
	var event_name = "my event name"
	var event_payload = {"foo" : "1" }
	var event_namespace = "my_event_namespace"
	
	var event = playfab_event._assemble_event(event_name, event_payload, event_namespace)
	
	var expected_event_contents = EventContents.new()
	expected_event_contents.Name = event_name
	expected_event_contents.Payload = event_payload
	expected_event_contents.EventNamespace = event_namespace

	assert_is(event, EventContents)
	assert_eq(event.Name, expected_event_contents.Name)
	assert_eq(event.Payload, expected_event_contents.Payload)
	assert_eq(event.EventNamespace, expected_event_contents.EventNamespace)	
