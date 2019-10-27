extends Control
class_name Card

var origin_position = Vector2()

func instance():
	return load("res://source/card/Card.tscn").instance()

func save_position():
	origin_position = rect_position
