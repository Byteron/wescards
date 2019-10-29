extends Control
class_name Unit

const COLOR_GOLD = Color("ebca15")

static func instance():
	return load("res://source/unit/Unit.tscn").instance()

signal died(unit)

var actions := 0 setget _set_actions

var data = null
var tile = null

var team = 0
var team_color = Color("FFFFFF")

var is_hero = false
var is_dead = false

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

	is_hero = data.is_hero
	portrait.texture = data.portrait
	back.color = data.background
	melee.base = data.melee
	melee.value = data.melee
	ranged.base = data.melee
	ranged.value = data.ranged
	toughness.base = data.toughness
	toughness.value = data.toughness
	border.self_modulate = team_color

	if data.is_hero:
		portrait.get_node("Overlay").self_modulate = COLOR_GOLD
		portrait.get_node("Vignette").self_modulate = COLOR_GOLD

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
		is_dead = true

func kill():
	tile.unit = null
	emit_signal("died", self)
	queue_free()

func select():
	rect_scale = Vector2(1.2, 1.2)

func deselect():
	rect_scale = Vector2(1, 1)

func restore():
	if actions:
		toughness.value = clamp(toughness.value + 1, 0, data.toughness)

	actions = 1
	back.color = data.background

func _set_actions(value):
	actions = max(0, value)
	if not actions:
		back.color = Color("666666")
