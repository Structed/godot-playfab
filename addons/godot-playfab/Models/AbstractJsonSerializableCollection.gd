# This is a wrapper class around an Array
extends JsonSerializable
class_name AbstractJsonSerializableCollection


# Holds the items
var _Items: Array

# Specifies the type of the items in `_Items`, which in turn must inherit JsonSerializable.
# @example: Given a collection `StoreItemCollection`, by convention, `_Items` would be a collection of `StoreItem`.
# Thus, in the extending class you would add a constructor initialization like so:
# ```
# extends AbstractJsonSerializableCollection
# class_name StoreItemCollection
#
# func _init():
#     _item_type = StoreItem
# ```
#
var _item_type

# Appends an element at the end of the array (alias of push_back).
func append(item: JsonSerializable):
	_Items.append(item)


# Returns the number of elements in the array.
func size() -> int:
	return _Items.size()

# Clears the array. This is equivalent to using resize with a size of 0.
func clear():
	_Items.clear();


## MASSIVE HACK 😬
# Casts this collection and sub-objects to an Array of Dictionaries, recursively.
# The method name is only `to_dict` to keep the API compatible with `JsonSerializable`
# The return value is an ARRAY!
# @returns Array: An array of all the Dictionaries, marshaled from objects inheriting from `JsonSerializable`
func to_dict():
	var index = 0
	var dict = []	# Actually, Array of items! It's called dict to keep the API compatible with JsonSerializable
	for item in _Items:
		dict.append((item as JsonSerializable).to_dict())
		index += 1

	return dict


# Rehydrates a collection and appropriate sub-objects from a Dictionary, recursively
func from_dict(data, instance: JsonSerializable):
	var index = 0
	for item in data:
		var nested_instance = _item_type.new()
		nested_instance.from_dict(item, nested_instance)
		_Items.append(nested_instance)
		index += 1
