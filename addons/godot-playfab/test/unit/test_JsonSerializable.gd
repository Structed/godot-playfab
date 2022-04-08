extends "res://addons/gut/test.gd"

var model

func before_each():
	gut.p("ran setup", 2)
	model = JsonSerializableImpl.new()

func after_each():
	gut.p("ran teardown", 2)

func before_all():
	gut.p("ran run setup", 2)

func after_all():
	gut.p("ran run teardown", 2)


func test_implements_JsonSerializable():
	assert_is(model, JsonSerializable);


func test_to_dict_returns_dictionary():
	var dict = model.to_dict();
	assert_true(dict is Dictionary)



func generate_params__test_to_dict_returns_expected_dictionary():
	var instance_model = JsonSerializableImpl.new()
	return ParameterFactory.named_parameters(
		['actual', 'expected'],
		[
			[model.to_dict(),
			{
				"foo": "foo_value",
				"bar": "bar_value"
			}
		]])


func test_to_dict_returns_expected_dictionary(p = use_parameters(generate_params__test_to_dict_returns_expected_dictionary())):
	var result = compare_deep(p.expected, p.actual)
	assert_true(result.are_equal)
