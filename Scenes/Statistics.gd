extends VBoxContainer

var start_time: int
var waiting = false


# Called when the node enters the scene tree for the first time.
func _ready():
	start()


func _process(_delta):
	if (waiting):
		$LayoutHbox/ElapsedTimeLabel.text = str(get_elapsed_time())


func _on_StopWaitingButton_pressed():
	if (waiting):
		waiting = false
		$StopWaitingButton.text = "Start waiting for Godot!"
	else:
		start()


func get_elapsed_time() -> int:
	return OS.get_unix_time() - start_time


func start():
	start_time = OS.get_unix_time()
	waiting = true
	$StopWaitingButton.text = "Stop waiting for Godot!"