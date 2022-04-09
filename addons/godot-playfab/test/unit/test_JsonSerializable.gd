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
	return ParameterFactory.named_parameters(
		# Parameter names
		['actual', 'expected'],
		[
			[
				# Just string values
				model,
				{
					"foo": "foo_value",
					"bar": "bar_value"
				}
			],
			[
				# Sub-property serialization
				JsonSerializableImpl.WithSetObjectProperty.new(),
				{
					"sub_prop": {
						"foo": "bar",
					}
				}
			],
			[
				# All empty property values
				JsonSerializableImpl.WithNotSetObjectProperty.new(),
				{
					"sub_prop": null
				}
			]
		]
		)


func test_to_dict_returns_expected_dictionary(p = use_parameters(generate_params__test_to_dict_returns_expected_dictionary())):
	var result = compare_deep(p.expected, p.actual.to_dict())
	assert_true(result.are_equal)


func test_to_dictionary_serializes_native_objects_to_class_name():
	var obj = JsonSerializableImpl.WithBuiltinObject.new();
	var actual = obj.to_dict()
	obj.node.free()	# Need to free, otehrwiese we'll be leaving an orphan

	assert_eq("Node", actual.node)


func test_get_class_instance_returns_instance_of_correct_type():
	# Arrange
	var js = JsonSerializable.new()

	# Act
	var instance: JsonSerializableImpl = js.get_class_instance("JsonSerializableImpl")

	# Assert
	assert_typeof(instance, TYPE_OBJECT)
	assert_true("foo" in instance)
	assert_true("bar" in instance)