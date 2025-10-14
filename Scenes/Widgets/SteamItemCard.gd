extends Control
class_name SteamItemCard

## A card widget for displaying Steam inventory items

func reset_steam_item(item_data: Dictionary, item_definition: Dictionary) -> void:
	# Steam item data structure:
	# item_id: Steam item instance ID
	# definition: Item definition ID
	# quantity: Stack quantity

	var item_name: String = item_definition.get("name", "Unknown Item")
	var item_description: String = item_definition.get("description", "")
	var quantity: int = item_data.get("quantity", 1)
	var icon_url: String = item_definition.get("icon_url", "")

	%Title.text = item_name
	%Description.text = item_description
	%Amount.text = "%dx" % quantity

	# Load the item icon from URL if available
	if icon_url != "":
		_load_image_from_url(icon_url)
	else:
		%ItemIcon.hide()


func _load_image_from_url(url: String) -> void:
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_image_loaded)

	var error = http_request.request(url)
	if error != OK:
		print("Failed to request image from URL: ", url)
		%ItemIcon.hide()


func _on_image_loaded(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		print("Failed to load image. Result: %s, Response code: %s" % [result, response_code])
		%ItemIcon.hide()
		return

	var image = Image.new()
	var error = image.load_png_from_buffer(body)

	if error == ERR_FILE_UNRECOGNIZED:
		error = image.load_jpg_from_buffer(body)

	if error != OK:
		print("Failed to load image from buffer")
		%ItemIcon.hide()
		return

	var texture = ImageTexture.create_from_image(image)
	%ItemIcon.texture = texture
	%ItemIcon.show()

