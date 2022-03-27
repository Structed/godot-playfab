extends WAT.Test

var collection

func title() -> String:
	return "AbstractJsonSerializableCollection Test"

func start() -> void:
	pass

func pre() -> void:
	# Reset before each test
	collection = AbstractJsonSerializableCollection.new()

func post() -> void:
	pass

func end() -> void:
	pass


func test_assert_collection_items_initialized_with_zero_Items():
	asserts.is_equal(0, collection._Items.size())

func test_assert_eq_size_zero_after_instanciation():
	asserts.is_equal(0, collection.size(), "Initialization failed")

func test_assert_append_adds_item():
	collection.append([])

	asserts.is_equal(1, collection.size())

func test_assert_clear_removes_all_items():
	collection.append([])
	collection.append([])

	asserts.is_equal(2, collection.size())
	collection.clear()


	asserts.is_equal(0, collection.size())

# We want validated that this returns an Array
func test_to_dict_returns_array():
	var dict = collection.to_dict()

	asserts.is_true(dict is Array)

# func test_to_dict_returns_expected_array_of_values():
# 	var item_1 = JsonSerializable.new()
# 	var item_2 = JsonSerializable.new()

# 	item_1["foo"] = "foo_value"
# 	item_2["foo"] = "bar_value"

# 	collection.append(item_1)
# 	collection.append(item_2)

# 	var expected = [item_1, item_2, item_2]
# 	var actual = collection.to_dict()

# 	asserts.is_equal(expected, actual)