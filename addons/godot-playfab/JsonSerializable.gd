extends Reference
class_name JsonSerializable


func _get_type_for_property(property_name: String):
	push_error("No mapping for property " + property_name)
	return ""

func to_dict() -> Dictionary:

	var dict = {}
	var props = get_property_list()

	# Skipping the first 3 items because they are metadata we do not need
	for i in range(3, props.size()):
		var prop = props[i]
		var name = prop["name"] # The name of the property on the object. WIll be used to access its's value
		var type = prop["type"]	# The godot built-in type (Array, Object etc)

		if (type == TYPE_OBJECT):
			# Get the value of the property
			var sub_prop = get(name)
			if sub_prop == null:
				# Actually set null if null
				dict[name] = null
			elif sub_prop.has_method("to_dict"):
				# Handle recursive property
				dict[name] = sub_prop.to_dict()
			else:
				var type_name = sub_prop.get_class()
				# No to_dict method - likely an error!
				# If it is a builtin class, however, a special handler needs to be iomplemented here.
				push_error("If '%s' is not a builtin class, please implement a to_dict() method! If it IS a builtin class, a special handler needs to be implemented in JsonSerializable." % type_name)
				dict[name] = type_name
		else:
			# Get the value of the property
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


# Instanciate a class by name
# @param name: String - A class name
# @returns Reference - The instance reference
func get_class_instance(name: String) -> Reference:
	var classes = ProjectSettings.get_setting("_global_script_classes")
	for element in classes:
		if element["class"] == name:
			return load(element["path"]).new()


	push_error("Class \"" + name + "\" could not be found")
	return null
