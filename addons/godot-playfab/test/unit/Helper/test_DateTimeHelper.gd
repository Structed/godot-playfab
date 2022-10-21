extends "res://addons/gut/test.gd"

func test_to_date_time_returns_string():
	var date_time_helper = DateTimeHelper.new()
	var datetime_string = date_time_helper.to_date_time(0, 123)
	assert_typeof(datetime_string, TYPE_STRING)

func test_to_date_time_returns_zero_padded_elements():
	var date_time_helper = DateTimeHelper.new()
	
	var datetime_string = date_time_helper.to_date_time(0, 123)
	var expected = "1970-01-01T00:00:00.123Z"
	assert_eq(datetime_string, expected)

var different_params = [
	[0, "1970-01-01T00:00:00.123Z"],
	[1, "1970-01-01T00:00:01.123Z"],
	[60, "1970-01-01T00:01:00.123Z"],
	[3600, "1970-01-01T01:00:00.123Z"]
]
func test_to_date_time_returns_different_timestamps(params=use_parameters(different_params)):
	var date_time_helper = DateTimeHelper.new()
	
	var datetime_string = date_time_helper.to_date_time(params[0], 123)
	var expected = "1970-01-01T00:00:00.123Z"
	assert_eq(datetime_string, params[1])
