extends Reference
class_name SafeTimer

class FrameTimer_ extends Node:
	signal timeout
	
	var frames : int = 1
	
	func _ready() -> void:
		get_tree().connect("idle_frame", self, "_on_timeout")

	func _on_timeout() -> void:
		frames -= 1
		if frames == 0:
			emit_signal("timeout")
			queue_free()


static func idle_frame(node:Node, frames:int = 1):
	var t   := FrameTimer_.new()
	t.frames = frames
	node.add_child(t)
	
	return t

class FTimerI_ extends Node:
	signal timeout
	
	var frames : int = 1
	
	func _ready() -> void:
		get_tree().connect("physics_frame", self, "_on_timeout")

	func _on_timeout() -> void:
		frames -= 1
		if frames == 0:
			emit_signal("timeout")
			queue_free()

static func physics_frame(node:Node, frames:int = 1):
	var t   := FTimerI_.new()
	t.frames = frames
	node.add_child(t)
	
	return t

class TTimer_ extends Timer:
	func _on_timeout() -> void:
		queue_free()

static func create_timer(node:Node, time:float):
	var t   := TTimer_.new()
	t.wait_time = time
	t.autostart = true
	t.connect("timeout", t, "_on_timeout")
	node.add_child(t)

	return t
