extends "res://addons/gut/test.gd"

var model

func before_each():
	gut.p("ran setup", 2)
	model = JsonSerializable.new()

func after_each():
	gut.p("ran teardown", 2)

func before_all():
	gut.p("ran run setup", 2)

func after_all():
	gut.p("ran run teardown", 2)


func test_to_dict_returns_dictionary():
	var dict = model.to_dict();
	assert_true(dict is Dictionary)