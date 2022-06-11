extends "res://addons/gut/test.gd"

var collection

func before_each():
	gut.p("ran setup", 2)
	collection = AbstractJsonSerializableCollection.new()

func after_each():
	gut.p("ran teardown", 2)

func before_all():
	gut.p("ran run setup", 2)

func after_all():
	gut.p("ran run teardown", 2)


func test_assert_collection_items_initialized_with_zero_Items():
	assert_eq(0, collection._Items.size(), "Initialization failed")

func test_assert_eq_size_zero_after_instanciation():
	assert_eq(0, collection.size(), "Initialization failed")

func test_assert_append_adds_item():
	collection.append([])

	assert_eq(1, collection.size())

func test_assert_clear_removes_all_items():
	collection.append([])
	collection.append([])

	assert_eq(2, collection.size())
	collection.clear()


	assert_eq(0, collection.size())

# We want validated that this returns an Array
func test_to_dict_returns_array():
	var dict = collection.to_dict()

	assert_true(dict is Array)


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

	assert_true("foo" in instance._Items[0])
	assert_true("bar" in instance._Items[0])
	assert_eq(instance._Items[0].foo, "bar1")
	assert_eq(instance._Items[0].bar, 1)

	assert_true("foo" in instance._Items[1])
	assert_true("bar" in instance._Items[1])
	assert_eq(instance._Items[1].foo, "bar2")
	assert_eq(instance._Items[1].bar, 2)
