extends Control
class_name Land

signal destroyed(land)

static func instance():
	return load("res://source/land/Land.tscn").instance()

var data = null

var tile = null

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

func destroy():
	emit_signal("destroyed", self)
	queue_free()

func apply_effect():
	if tile.unit and data.effect:
		tile.unit.apply_effect(data.effect)

func remove_effect():
	if tile.unit and data.effect:
		tile.unit.remove_effect(data.effect)

func update_display():
	name_label.text = data.alias
	back.color = data.tint
	portrait.texture = data.image
	border.modulate = team_color
