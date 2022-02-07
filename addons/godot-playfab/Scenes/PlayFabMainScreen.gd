tool
extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Generate_pressed():
	print("test")
#	var model = to_model($Input.text)
#	$Output.text = model
	
	$Output.text = split_regex($Input.text)

static func to_model(input: String) -> String:
	var lines = input.split("\\n", false)
	
	var model = ""
	for line in lines:
		var str_line = (line as String)
		print("\"%s\" has %d characters" % [str_line, str_line.length()])
		if not str_line.empty():
			model += str_line
		else:
			pass
			#print("\"%s\" has %d characters" % [str_line, str_line.length()])
		print(line)
		
	return model

func split_regex(input: String):
	var regex = RegEx.new()
	regex.compile("(.+)\\s?$")
	#regex.compile("^(.*)\\n(.*)\\n(.*)\n$")
	
	# ^(.*)\n(.*)\n(.*)\n$
	
	var result_string = ""
	var index = 0
	var results = []
	var dict = {}
	
	
	for result in regex.search_all(input):
		var var_name = result.get_string(1) as String
		var type = result.get_string(2) as String
		var comment = result.get_string(3) as String
		var formatted = "##%s\\nvar %s: %s" % [comment, var_name, type]
		results.push_back(formatted)
		print(formatted)

	result_string = PoolStringArray(results).join("\\r\\n")
	#print(results)
		
	return result_string
