
# GdUnit generated TestSuite
class_name JsonSerializableTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/godot-playfab/JsonSerializable.gd'




var model

func before_test():
	model = auto_free(JsonSerializableImpl.new())


func test_implements_JsonSerializable():
	assert_object(model).is_instanceof(JsonSerializable)


func test_to_dict_returns_dictionary():
	var dict = model.to_dict();
	assert_bool(dict is Dictionary).is_true()


# Parameterized tests currently do not seem to work, so I created 3 individual tests below
#func test_to_dict_returns_expected_dictionary(actual: JsonSerializableImpl, expected: Dictionary, test_parameters := [
#		[
#			# Just string values
#			model,
#			{
#				"foo": "foo_value",
#				"bar": "bar_value"
#			}
#		],
#		[
#			# Sub-property serialization
#			JsonSerializableImpl.WithSetObjectProperty.new(),
#			{
#				"sub_prop": {
#					"foo": "foo_value",
#					"bar": 0
#				}
#			}
#		],
#		[
#			# All empty property values
#			JsonSerializableImpl.WithNotSetObjectProperty.new(),
#			{
#				"sub_prop": null
#			}
#		]
#	]):
#
#	assert_dict(actual.to_dict()).is_equal(expected)

func test_to_dict_returns_expected_dictionary_1():
	# Just string values
	var expected := {
		"foo": "foo_value",
		"bar": "bar_value"
	}
	var actual = model.to_dict()
	assert_dict(actual).is_equal(expected)


func test_to_dict_returns_expected_dictionary_2():
	# Sub-property serialization
	var dict = JsonSerializableImpl.WithSetObjectProperty.new()
	var expected := {
		"sub_prop": {
			"foo": "foo_value",
			"bar": 0
		}
	}
	var actual = dict.to_dict()
	assert_dict(actual).is_equal(expected)

func test_to_dict_returns_expected_dictionary_3():
	# All empty property values
	var dict = JsonSerializableImpl.WithNotSetObjectProperty.new()
	var expected := {
		"sub_prop": null
	}
	var actual = dict.to_dict()
	assert_dict(actual).is_equal(expected)


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
	assert_str(actual.node).is_equal("Node")


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
	assert_str(actual.foo).is_equal(expected.foo)
	assert_str(actual.bar).is_equal(expected.bar)


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
	assert_bool("foo" in actual.sub_prop).is_true()
	assert_str(actual.sub_prop.foo).is_equal("1")


func test_from_dict_with_empty_values_returns_proper_instance():
	var dict = {
		"sub_prop": null
	}

	var actual = JsonSerializableSubPropImpl.new()

	# Act
	actual.from_dict(dict, actual)

	# Assert
	assert_bool("sub_prop" in actual).is_true()
	assert_object(actual.sub_prop).is_null()


func test_get_class_instance_returns_instance_of_correct_type():
	# Arrange
	var js = JsonSerializable.new()

	# Act
	var instance: JsonSerializableImpl = js.get_class_instance("JsonSerializableImpl")

	# Assert
	assert_object(instance).is_instanceof(Object)
	assert_bool("foo" in instance).is_true()
	assert_bool("bar" in instance).is_true()
