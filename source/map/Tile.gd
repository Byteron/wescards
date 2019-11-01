extends ColorRect
class_name Tile

signal captured(cell)

var unit = null
var land = null

var cell = null

export var is_village = false
export var income = 0

export(Array, Vector2) var neighbors = []

onready var flag := $Flag
onready var flag_label := $Flag/Label

func _ready() -> void:
	if is_village:
		flag_label.text = "+%d" % income
		flag.show()

func capture(team, team_color):
	if not is_village:
		return

	flag.self_modulate = team_color
	emit_signal("captured", team, cell)
