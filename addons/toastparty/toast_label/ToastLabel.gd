extends Label

signal remove_label(ToastLabel)

var resolution = Vector2.ZERO

# Text margin with box parent
const margins = {"left": 12, "top": 7, "right": 12, "bottom": 7}
# margin between buttons
const margin_between = 23

# offset position box with screen position
const offset_position = Vector2(10, 10)

var button_size
var _tween_in: Tween

# local variables
var gravity = "bottom"  # top, bottom
var direction = "center"  # left, right, center
var timer_to_destroy = 2  # seconds by default


func _ready():
	_set_resolution()
	button_size = self.size

	# start position
	_tween_destroy_label_timer()

func _clean_config(config: Dictionary) -> Dictionary:
	var _config = config
	if not _config.has("text"):
		_config["text"] = "Toast Label"
	if not _config.has("text_size"):
		_config["text_size"] = 18
	if not _config.has("bgcolor"):
		_config["bgcolor"] = Color(0, 0, 0, .7)
	if not _config.has("direction"):
		_config["direction"] = "center"
	if not _config.has("gravity"):
		_config["gravity"] = "bottom"
	if not _config.has("color"):
		_config["color"] = Color(1, 1, 1, 1)
	if not _config.has("use_font"):
		_config["use_font"] = true
	return _config


func init(config: Dictionary) -> void:
	# TODO: add config validation
	var config_cleaned = _clean_config(config)

	update_text(config_cleaned.text)
	_set_bg_color(config_cleaned.bgcolor)
	_set_color(config_cleaned.color)
	_set_font(config_cleaned.use_font)
	_set_text_size(config_cleaned.text_size)

	direction = config_cleaned.direction
	gravity = config_cleaned.gravity

	position.y = get_y_pos(-100, gravity)

	_set_margins()
	_set_shadow_direction()


func update_text(_text: String) -> void:
	self.text = _text
	button_size = self.size
	update_x_position()


func move_to(index: int) -> void:
	update_x_position()

	var offset_y = (margin_between + button_size.y) * index
	var _y = get_y_pos(offset_y, gravity)

	# bottom
	if index == 0:
		_tween_in = get_tree().create_tween()
		_tween_in.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS) # pause mode
		_tween_in.stop()
		var delayed = 0.03
		(
			_tween_in
			. tween_property(self, "position", Vector2(position.x, _y), .3)
			. set_trans(Tween.TRANS_QUINT)
			. set_ease(Tween.EASE_IN)
			. set_delay(delayed)
		)
		_tween_in.play()
	else:
		_tween_in = get_tree().create_tween()
		_tween_in.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS) # pause mode
		_tween_in.stop()
		(
			_tween_in
			. tween_property(self, "position", Vector2(position.x, _y), .3)
			. set_trans(Tween.TRANS_ELASTIC)
			. set_ease(Tween.EASE_IN_OUT)
		)
		_tween_in.play()


func _tween_destroy_label_complete() -> void:
	# Send event complete
	emit_signal("remove_label", self)
	queue_free()


func _tween_destroy_label_timer():
	# tween alpha to 0
	var tween_alpha = get_tree().create_tween()
	tween_alpha.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS) # pause mode
	tween_alpha.tween_property(self, "modulate:a", 0, 0.8).set_delay(timer_to_destroy)
	tween_alpha.tween_callback(_tween_destroy_label_complete)


func get_y_pos(offset = 0, _gravity = "top") -> float:
	# left position.x = margins.left + offset_position.x
	var _y_pos = 0
	if _gravity == "top":
		_y_pos = margins.top + offset_position.y + offset
	else:
		_y_pos = resolution.y - margins.top - button_size.y - offset_position.y - offset
	return _y_pos


func update_x_position() -> void:
	_set_resolution()

	if direction == "left":
		position.x = margins.left + offset_position.x
	elif direction == "center":
		position.x = (resolution.x / 2) - (size.x / 2)
	else:
		position.x = resolution.x - margins.left - size.x - offset_position.x

func _set_color(color: Color) -> void:
	# set color
	var theme_override = self.get("label_settings")
	theme_override.set("font_color", color)


func _set_font(use_font: bool) -> void:
	# set font
	if use_font == false:
		var theme_override = self.get("label_settings")
		theme_override.set("font", null)


func _set_margins() -> void:
	# set margins
	var theme_override = self.get("theme_override_styles/normal")
	theme_override.set("expand_margin_left", margins.left)
	theme_override.set("expand_margin_top", margins.top)
	theme_override.set("expand_margin_right", margins.right)
	theme_override.set("expand_margin_bottom", margins.bottom)


func _set_shadow_direction() -> void:
	# set shadow direction
	var shadow_offset_abs = 2
	var theme_override = self.get("theme_override_styles/normal")
	if gravity == "top" and direction == "left":
		theme_override.set("shadow_offset", Vector2(-shadow_offset_abs, shadow_offset_abs))
	elif gravity == "top" and direction == "right":
		theme_override.set("shadow_offset", Vector2(shadow_offset_abs, shadow_offset_abs))

	elif gravity == "bottom" and direction == "left":
		theme_override.set("shadow_offset", Vector2(-shadow_offset_abs, shadow_offset_abs))
	elif gravity == "bottom" and direction == "right":
		theme_override.set("shadow_offset", Vector2(shadow_offset_abs, shadow_offset_abs))

	elif gravity == "top" and direction == "center":
		theme_override.set("shadow_offset", Vector2(0, shadow_offset_abs))
	elif gravity == "bottom" and direction == "center":
		theme_override.set("shadow_offset", Vector2(0, shadow_offset_abs))


func _set_text_size(text_size: int) -> void:
	# set text size
	var theme_override = self.get("label_settings")
	theme_override.set("font_size", text_size)


func _set_bg_color(color: Color) -> void:
	# set bg color
	var theme_override = self.get("theme_override_styles/normal")
	theme_override.set("bg_color", color)


func _set_resolution():
	resolution.x = get_viewport().get_visible_rect().size.x
	resolution.y = get_viewport().get_visible_rect().size.y
