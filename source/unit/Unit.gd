extends Control
class_name Unit

static func instance():
	return load("res://source/unit/Unit.tscn").instance()

var data = null
var tile = null
var team_color = Color("FFFFFF")

onready var portrait := $MarginContainer/MarginContainer/VBoxContainer/Portrait
onready var back := $MarginContainer/Background
onready var border := $MarginContainer/Border

onready var melee := $MarginContainer/MarginContainer/VBoxContainer/Portrait/HBoxContainer/HBoxContainer/Melee
onready var ranged := $MarginContainer/MarginContainer/VBoxContainer/Portrait/HBoxContainer/HBoxContainer/Ranged
onready var toughness := $MarginContainer/MarginContainer/VBoxContainer/Portrait/HBoxContainer/Toughness

func _ready() -> void:
	propagate_call("set_mouse_filter", [ Control.MOUSE_FILTER_IGNORE ])
	update_display()

func update_display():

	if not data:
		return

	portrait.texture = data.portrait
	back.color = data.background

	melee.value = data.melee
	ranged.value = data.ranged
	toughness.value = data.toughness
	border.self_modulate = team_color

func initialize(card_data):
	data = card_data
