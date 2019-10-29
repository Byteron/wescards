extends Control
class_name Card

var origin_position = Vector2()

var locked = false

var data = null

var team_color := Color("FFFFFF") setget _set_team_color

onready var portrait = $MarginContainer/VBoxContainer/Portrait
onready var description = $MarginContainer/VBoxContainer/Description/Label
onready var alias = $MarginContainer/VBoxContainer/Titel/Name/Label
onready var back = $Background

onready var cost := $MarginContainer/VBoxContainer/Titel/Cost
onready var melee := $MarginContainer/VBoxContainer/Titel/Melee
onready var ranged := $MarginContainer/VBoxContainer/Titel/Ranged
onready var toughness := $MarginContainer/VBoxContainer/Titel/Toughness

onready var body := $MarginContainer
onready var border := $Border

static func instance():
	return load("res://source/card/Card.tscn").instance()

func _ready() -> void:
	body.propagate_call("set_mouse_filter", [ Control.MOUSE_FILTER_IGNORE ])
	update_display()

func initialize(card_data):
	data = card_data

func update_display():

	if not data:
		return

	alias.text = data.alias
	description.text = data.description
	portrait.texture = data.portrait
	back.color = data.background

	cost.value = data.cost
	melee.value = data.melee
	ranged.value = data.ranged
	toughness.value = data.toughness
	border.self_modulate = team_color

func make_unit():
	mouse_filter = MOUSE_FILTER_IGNORE
	$MarginContainer/VBoxContainer/Description.hide()
	$MarginContainer/VBoxContainer/Legals.hide()
	cost.hide()

func save_position():
	origin_position = rect_global_position

func _set_team_color(color):
	team_color = color
	border.self_modulate = team_color
