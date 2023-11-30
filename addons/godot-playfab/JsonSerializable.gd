extends RefCounted
class_name JsonSerializable

# **VIRTUAL**
#
# Returns the type of a property of this class
# Will **always** `push_error` and return an empty string in this base class! Should be overridden.
# @param property_name: String - The name of the property to lookup a type for
# @returns - The type's name
func _get_type_for_property(property_name: String):
	push_error("No mapping for property " + property_name)
	return ""

# Marshals an object - recursively - into a dictionary
# @returns Dictionary - A Dictionary representation of this object instance
func to_dict() -> Dictionary:

	var dict = {}
	var props = get_property_list()

	# Skipping the first 3 items because they are metadata we do not need
	for prop in props:
		var name = prop["name"] # The name of the property on the object. Will be used to access its's value
		var type = prop["type"]	# The godot built-in type (Array, Object etc)
		var usage = prop["usage"]	# is a combination of PropertyUsageFlags.
		
		# If it's not PROPERTY_USAGE_SCRIPT_VARIABLE, it's not an actual property and we can ignore it
		if (usage & PROPERTY_USAGE_SCRIPT_VARIABLE) != PROPERTY_USAGE_SCRIPT_VARIABLE:
			continue

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
				#push_error("If '%s' is not a builtin class, please implement a to_dict() method! If it IS a builtin class, a special handler needs to be implemented in JsonSerializable." % type_name)
				print_debug("If '%s' is not a builtin class, please implement a to_dict() method! If it IS a builtin class, a special handler needs to be implemented in JsonSerializable." % type_name)
				dict[name] = type_name
		else:
			# Get the value of the property
			dict[name] = get(name)

	return dict

# Demarshals a Dictionary - recursively - into an object of a specific class instance.
# @param data: Dictionary - The Dictionary to demarshal
# @param instance: JsonSerializable: An instance of a class implementing JsonSerializable.
# @returns void
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
		elif data[key] == null:
			instance.set(key, null)
		else:
			# If object data type, instantiate object
			var type_name = instance._get_type_for_property(key)
			var nested_instance = instance.get_class_instance(type_name)
			# fill properties
			nested_instance.from_dict(data[key], nested_instance)
			instance.set(key, nested_instance)


# Instantiate a class by name
# @param name: String - A class name
# @returns RefCounted - The instance reference
func get_class_instance(name: String):
	var config = ConfigFile.new()
	config.load("res://.godot/global_script_class_cache.cfg")
	var classes = config.get_value('', 'list', [])
	for element in classes:
		if element["class"] == name:
			return load(element["path"]).new()


	push_error("Class \"" + name + "\" could not be found")
	return null
