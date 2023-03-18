class_name GdUnitProperty
extends RefCounted

var _name :String
var _help :String
var _type :int
var _value
var _value_set :PackedStringArray
var _default


func _init(p_name :String, p_type :int, p_value, p_default_value, p_help :="", p_value_set := PackedStringArray()):
	_name = p_name
	_type = p_type
	_value = p_value
	_value_set = p_value_set
	_default = p_default_value
	_help = p_help


func name() -> String:
	return _name


func type() -> int:
	return _type


func value():
	return _value


func value_set() -> PackedStringArray:
	return _value_set


func is_selectable_value() -> bool:
	return not _value_set.is_empty()


func set_value(p_value) -> void:
	match _type:
		TYPE_STRING:
			_value = str(p_value)
		TYPE_BOOL:
			_value = bool(p_value)
		TYPE_INT:
			_value = int(p_value)
		TYPE_FLOAT:
			_value = float(p_value)


func default():
	return _default


func category() -> String:
	var elements := _name.split("/")
	if elements.size() > 3:
		return elements[2]
	return ""


func help() -> String:
	return _help


func _to_string() -> String:
	return "%-64s %-10s %-10s (%s) help:%s set:%s" % [name(), type(), value(), default(), help(), _value_set]
