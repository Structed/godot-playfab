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


# Parameter generator function for `test_to_dict_returns_expected_dictionary`
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
						"foo": "foo_value",
						"bar": 0
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


# TODO: likely, this is not a good test:
# It tests for a behaviour that is not intended,
# as users should not serialize native classes.
# A debug_print() will warn users if they are serializiong native classes.
func test_to_dict_serializes_native_objects_to_class_name():
	# Arrange
	var obj = JsonSerializableImpl.WithBuiltinObject.new();

	# Act
	var actual = obj.to_dict()
	obj.node.free()	# Need to free, otherwise we'll be leaving an orphan

	# Assert
	assert_eq("Node", actual.node)


func test_from_dict_with_just_strings_returns_proper_instance():
	# Arrange
	var dict = {
		"foo": "1",
		"bar": "2"
	}
	var actual = JsonSerializableImpl.new()
	var expected = JsonSerializableImpl.new()
	expected.foo = "1"
	expected.bar = "2"

	# Act
	actual.from_dict(dict, actual)

	# Assert
	assert_eq(expected.foo, actual.foo)
	assert_eq(expected.bar, actual.bar)


func test_from_dict_with_sub_property_returns_proper_instance():
	# Arrange
	var dict = {
		"sub_prop": {
			"foo": "1",
		}
	}
	var actual = JsonSerializableSubPropImpl.new()

	# Act
	actual.from_dict(dict, actual)

	# Assert
	assert_true("foo" in actual.sub_prop)
	assert_eq(actual.sub_prop.foo, "1")


func test_from_dict_with_empty_values_returns_proper_instance():
	var dict = {
		"sub_prop": null
	}

	var actual = JsonSerializableSubPropImpl.new()

	# Act
	actual.from_dict(dict, actual)

	# Assert
	assert_true("sub_prop" in actual)
	assert_null(actual.sub_prop)


func test_get_class_instance_returns_instance_of_correct_type():
	# Arrange
	var js = JsonSerializable.new()

	# Act
	var instance: JsonSerializableImpl = js.get_class_instance("JsonSerializableImpl")

	# Assert
	assert_typeof(instance, TYPE_OBJECT)
	assert_true("foo" in instance)
	assert_true("bar" in instance)
