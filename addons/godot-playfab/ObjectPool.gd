extends Node
class_name ObjectPool


var _prototype: Object
var _idle_pool: Array = []
var _busy_pool: Array = []


func _init(prototype: Object) -> void:
	_prototype = prototype


func get_instance() -> Object:
	if _idle_pool.size() > 0:
		var instance = _idle_pool.pop_back()
		_busy_pool.append(instance)
		return instance
	else:
		var instance: Object = _create_instance()
		_busy_pool.append(instance)
		return instance


func _create_instance() -> Object:
	var instance: Object = _prototype.duplicate()
	add_child(instance)
	return instance

func release_instance(instance: Object) -> void:
	if instance in _busy_pool:
		_busy_pool.erase(instance)
		_idle_pool.append(instance)
	else:
		push_error("Instance not found in busy pool.")
