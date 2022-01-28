extends Node


var play_fab: PlayFab


# Called when the node enters the scene tree for the first time.
func _ready():
	play_fab = PlayFab.new("544D3")
	add_child(play_fab)
