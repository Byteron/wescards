extends Control
class_name Land

static func instance():
	return load("res://source/land/Land.tscn").instance()

var data = null

var tile = null

var effect = null

var team := 0
var team_color := Color("666666")

onready var name_label := $Name
onready var portrait := $Portrait
onready var back := $Background
onready var border := $Border

func _ready() -> void:
	propagate_call("set_mouse_filter", [ Control.MOUSE_FILTER_IGNORE ])
	update_display()

func initialize(land_data):
	data = land_data

	if not data.effect:
		print("no effect data")
		return

	effect = Effect.new(data.effect.property, data.effect.operation, data.effect.value)

func update_display():
	name_label.text = data.alias
	back.color = data.tint
	portrait.texture = data.image
	border.modulate = team_color
