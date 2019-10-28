extends Control
class_name Card

var origin_position = Vector2()

var locked = false

onready var portrait = $MarginContainer/VBoxContainer/Portrait
onready var description = $MarginContainer/VBoxContainer/Description/Label
onready var alias = $MarginContainer/VBoxContainer/Titel/Name/Label
onready var back = $Background

onready var cost := $MarginContainer/VBoxContainer/Titel/Cost/Label
onready var strength := $MarginContainer/VBoxContainer/Titel/Strength/Label
onready var defense := $MarginContainer/VBoxContainer/Titel/Defense/Label

onready var body := $MarginContainer

static func instance():
	return load("res://source/card/Card.tscn").instance()

func _ready() -> void:
	body.propagate_call("set_mouse_filter", [ Control.MOUSE_FILTER_IGNORE ])

func initialize(data: CardData):
	alias.text = data.alias
	description.text = data.description
	portrait.texture = data.portrait
	back.color = data.background

	cost.text = "%d" % data.cost
	strength.text = "%d" % data.strength
	defense.text = "%d" % data.defense

func make_unit():
	$MarginContainer/VBoxContainer/Description.hide()
	$MarginContainer/VBoxContainer/Legals.hide()
	$MarginContainer/VBoxContainer/Titel/Cost.hide()

func save_position():
	origin_position = rect_global_position
