extends Control
class_name Card

var origin_position = Vector2()

onready var portrait = $Portrait
onready var description = $Description
onready var alias = $Name
onready var back = $Background

static func instance():
	return load("res://source/card/Card.tscn").instance()

func initialize(data: CardData):
	alias.text = data.alias
	description.text = data.description
	portrait.texture = data.portrait
	back.color = data.background

func save_position():
	origin_position = rect_position
