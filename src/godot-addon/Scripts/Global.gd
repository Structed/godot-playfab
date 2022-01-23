extends Node


var pf: Pf


# Called when the node enters the scene tree for the first time.
func _ready():
	pf = Pf.new("544D3")
	add_child(pf)
