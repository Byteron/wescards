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
onready var defense := $MarginContainer/MarginContainer/VBoxContainer/Portrait/HBoxContainer/Defense
onready var health := $MarginContainer/MarginContainer/VBoxContainer/Portrait/HBoxContainer/Health

onready var greyscale := $MarginContainer/Greyscale

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
	defense.base = data.defense
	defense.value = data.defense
	health.base = data.health
	health.value = data.health
	border.self_modulate = team_color

	if data.is_hero:
		portrait.get_node("Overlay").self_modulate = COLOR_GOLD
		portrait.get_node("Vignette").self_modulate = COLOR_GOLD

func initialize(card_data):
	data = card_data

func hurt(damage):
	if not damage:
		return

	health.value = max(health.value - damage, 0)

	var popup = PopupLabel.instance()
	popup.value = damage
	popup.color = Color("FF0000")
	popup.rect_global_position = rect_global_position + rect_pivot_offset
	get_tree().current_scene.add_child(popup)

	if health.value == 0:
		is_dead = true

func kill():
	tile.unit = null
	emit_signal("died", self)
	queue_free()

func select():
	rect_scale = Vector2(1.2, 1.2)

func deselect():
	rect_scale = Vector2(1, 1)

func rest():
	if actions and is_damaged():
		var diff = clamp(health.value + 2, 0, data.health) - health.value
		health.value = clamp(health.value + 2, 0, data.health)

		if not diff:
			return

		var popup = PopupLabel.instance()
		popup.value = diff
		popup.color = Color("00FF00")
		popup.rect_global_position = rect_global_position + rect_pivot_offset
		get_tree().current_scene.add_child(popup)

func restore():
	actions = 1

func cleanup():
	greyscale.visible = false

func is_damaged():
	return health.value < health.base

func _set_actions(value):
	actions = max(0, value)
	if not actions:
		greyscale.visible = true
