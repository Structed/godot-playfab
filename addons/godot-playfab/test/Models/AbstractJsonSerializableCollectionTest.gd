
# GdUnit generated TestSuite
class_name AbstractJsonSerializableCollectionTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/godot-playfab/Models/AbstractJsonSerializableCollection.gd'


var collection :AbstractJsonSerializableCollection

func before_test():
	collection = auto_free(AbstractJsonSerializableCollection.new())

func test_assert_collection_items_initialized_with_zero_items() -> void:
	assert_that(collection._Items.size()).is_equal(0)

func test_assert_eq_size_zero_after_instanciation() -> void:
	assert_int(collection.size()).is_equal(0)

func test_assert_append_adds_item():
	collection.append(JsonSerializableImpl.new())

	assert_int(collection.size()).is_equal(1)

func test_assert_clear_removes_all_items():
	collection.append(JsonSerializableImpl.new())
	collection.append(JsonSerializableImpl.new())

	assert_int(2).is_equal(collection.size())
	collection.clear()

	assert_int(0).is_equal(collection.size())

# We want validated that this returns an Array
func test_to_dict_returns_array():
	var dict = collection.to_dict()

	assert_bool(dict is Array).is_true()


func test_from_dict_serializes_items():
	var data = [
		{
			"foo": "bar1",
			"bar": 1
		},
		{
			"foo": "bar2",
			"bar": 2
		}

	]

	var instance = TestCollection.new()
	instance.from_dict(data, instance);
	
	assert_bool("foo" in instance._Items[0]).is_true()
	assert_bool("bar" in instance._Items[0]).is_true()
	assert_str(instance._Items[0].foo).is_equal("bar1")
	assert_int(instance._Items[0].bar).is_equal(1)
	
	assert_bool("foo" in instance._Items[1]).is_true()
	assert_bool("bar" in instance._Items[1]).is_true()
	assert_str(instance._Items[1].foo).is_equal("bar2")
	assert_int(instance._Items[1].bar).is_equal(2)
