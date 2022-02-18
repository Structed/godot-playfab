extends Reference
class_name JsonSerializable

func to_dict() -> Dictionary:
	
	var dict = {}
	var props = get_property_list()
	
	# Skipping the first 3 items because they are metadata we do not need
	for i in range(3, props.size()):
		var prop = props[i]
		var name = prop["name"]
		var type = prop["type"]
		
		if (type == TYPE_OBJECT):
			var sub_prop = get(name)
			dict[name] = sub_prop.to_dict()
		else:
			dict[name] = get(name)
	
	return dict
