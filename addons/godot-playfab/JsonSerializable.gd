extends Reference
class_name JsonSerializable

var _type_mapping = {}

func _get_type_for_property(property_name: String):
	push_error("No mapping for property " + property_name)
	return ""

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

func from_dict(data: Dictionary, instance: JsonSerializable):
	
	var props = instance.get_property_list()
	for key in data.keys():
		
		var type		
		for prop in props:
			if prop["name"] == key:
				type = prop["type"]
				break
		
		# If basic data type - just set it
		if type != TYPE_OBJECT:
			instance.set(key, data[key])
		else:
		#if object data type
			# Instantiate object
			var type_name = instance._get_type_for_property(key)
			var nested_instance = get_class_instance(type_name)
			# fill properties
			nested_instance.from_dict(data[key], nested_instance)
			instance.set(key, nested_instance)

func get_class_instance(name: String) -> Reference:
	var classes = ProjectSettings.get_setting("_global_script_classes")
	for element in classes:
		if element["class"] == name:
			return load(element["path"]).new()
	
	
	push_error("Class \"" + name + "\" could not be found")
	return null
