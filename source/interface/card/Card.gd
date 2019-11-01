extends Control
class_name Card

var origin_position = Vector2()

var data = null

var locked = false
var greyed = false

var team_color := Color("FFFFFF") setget _set_team_color

onready var portrait = $MarginContainer/VBoxContainer/Portrait
onready var type := $MarginContainer/VBoxContainer/Type/Label
onready var description = $MarginContainer/VBoxContainer/Description/Label
onready var alias = $MarginContainer/VBoxContainer/Title/Name/Label
onready var back = $Background

onready var cost := $MarginContainer/VBoxContainer/Title/Cost

onready var body := $MarginContainer
onready var border := $Border

onready var greyscale := $Greyscale

static func instance():
	return load("res://source/interface/card/Card.tscn").instance()

func _ready() -> void:
	body.propagate_call("set_mouse_filter", [ Control.MOUSE_FILTER_IGNORE ])

func initialize(card_data, payable = true):
	greyed = !payable
	data = card_data

func update_display():

	if not data:
		return

	greyscale.visible = greyed

	alias.text = data.alias
	description.text = data.description
	portrait.texture = data.image
	back.color = data.tint

	cost.value = data.cost
	border.self_modulate = team_color

func save_position():
	origin_position = rect_global_position

func _set_team_color(color):
	team_color = color
	border.self_modulate = team_color
