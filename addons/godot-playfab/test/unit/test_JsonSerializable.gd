extends WAT.Test

var obj: JsonSerializable

func title() -> String:
	return "JsonSerializable Test"

func start() -> void:
	pass

func pre() -> void:
	# Reset before each test
	obj = JsonSerializable.new()

func post() -> void:
	pass

func end() -> void:
	pass

