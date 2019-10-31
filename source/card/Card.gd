extends Control
class_name Card

var origin_position = Vector2()

var data = null

var locked = false
var greyed = false

var team_color := Color("FFFFFF") setget _set_team_color

onready var portrait = $MarginContainer/VBoxContainer/Portrait
onready var description = $MarginContainer/VBoxContainer/Description/Label
onready var alias = $MarginContainer/VBoxContainer/Title/Name/Label
onready var back = $Background

onready var cost := $MarginContainer/VBoxContainer/Title/Cost
onready var melee := $MarginContainer/VBoxContainer/Stats/Melee
onready var ranged := $MarginContainer/VBoxContainer/Stats/Ranged
onready var defense := $MarginContainer/VBoxContainer/Stats/Defense
onready var health := $MarginContainer/VBoxContainer/Stats/Health

onready var body := $MarginContainer
onready var border := $Border

onready var ranged_separator = $MarginContainer/VBoxContainer/Stats/Separator2
onready var defense_separator = $MarginContainer/VBoxContainer/Stats/Separator3

onready var greyscale := $Greyscale

static func instance():
	return load("res://source/card/Card.tscn").instance()

func _ready() -> void:
	body.propagate_call("set_mouse_filter", [ Control.MOUSE_FILTER_IGNORE ])
	update_display()

func initialize(card_data, payable = true):
	greyed = !payable
	data = card_data

func update_display():

	if not data:
		return

	greyscale.visible = greyed

	alias.text = data.alias
	description.text = data.description
	portrait.texture = data.portrait
	back.color = data.background

	cost.value = data.cost
	melee.value = data.melee
	ranged.value = data.ranged
	ranged_separator.visible = ranged.visible
	defense.value = data.defense
	# defense_separator.visible = defense.visible
	health.value = data.health
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
