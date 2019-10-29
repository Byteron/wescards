extends Control
class_name Unit

static func instance():
	return load("res://source/unit/Unit.tscn").instance()

signal died(unit)

var actions := 0 setget _set_actions

var data = null
var tile = null

var team = 0
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

func hurt(damage):
	if not damage:
		return

	toughness.value = max(toughness.value - damage, 0)

	var popup = PopupLabel.instance()
	popup.value = damage
	popup.color = Color("FF0000")
	popup.rect_global_position = rect_global_position + rect_pivot_offset
	get_tree().current_scene.add_child(popup)

	if toughness.value == 0:
		tile.unit = null
		emit_signal("died", self)
		queue_free()

func select():
	rect_scale = Vector2(1.2, 1.2)

func deselect():
	rect_scale = Vector2(1, 1)

func restore():
	actions = 1
	toughness.value = data.toughness

func _set_actions(value):
	actions = max(0, value)
