extends Control
class_name Land

static func instance():
	return load("res://source/land/Land.tscn").instance()

var data = null

var tile = null

var team := 0
var team_color := Color("666666")

onready var name_label := $Name
onready var back := $Name/ColorRect
onready var border := $NinePatchRect

func _ready() -> void:
	propagate_call("set_mouse_filter", [ Control.MOUSE_FILTER_IGNORE ])
	update_display()

func initialize(land_data):
	data = land_data

func update_display():
	name_label.text = data.alias
	back.color = team_color
	border.modulate = team_color
