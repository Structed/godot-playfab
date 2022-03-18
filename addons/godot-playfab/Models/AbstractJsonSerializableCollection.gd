extends JsonSerializable
class_name AbstractJsonSerializableCollection


var _Items: Array


func append(item: JsonSerializable):
	_Items.append(item)


func size() -> int:
	return _Items.size()


func clear():
	_Items.clear();


func to_dict() -> Dictionary:
	var index = 0
	var dict = []
	for item in _Items:
		dict.append((item as JsonSerializable).to_dict())
		index += 1

	return dict

func from_dict(data: Dictionary, instance: JsonSerializable):
	var index = 0
	for item in data:
		_Items.append(.from_dict(item, instance))
		index += 1
