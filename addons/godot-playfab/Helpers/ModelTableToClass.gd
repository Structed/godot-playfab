extends Reference
class_name MTTC

static func to_model():
	var input = """
GetUserData	
boolean
Whether to get the player's custom data. Defaults to false

GetUserInventory	
boolean
Whether to get the player's inventory. Defaults to false

"""
	var lines = input.split("\\n", false)
	
	for line in lines:
		print_debug(line)

