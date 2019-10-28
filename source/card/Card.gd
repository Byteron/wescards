extends Control
class_name Card

var origin_position = Vector2()

onready var portrait = $Portrait
onready var description = $Description
onready var alias = $Titel/Name/Label
onready var back = $Background

onready var cost := $Titel/Cost/Label
onready var strength := $Titel/Strength/Label
onready var defense := $Titel/Defense/Label

static func instance():
	return load("res://source/card/Card.tscn").instance()

func initialize(data: CardData):
	alias.text = data.alias
	description.text = data.description
	portrait.texture = data.portrait
	back.color = data.background

	cost.text = "%d" % data.cost
	strength.text = "%d" % data.strength
	defense.text = "%d" % data.defense

func save_position():
	origin_position = rect_position
