extends ColorRect
class_name Tile

const INFO_DELAY = 1

signal captured(cell)

var unit = null
var land = null

var cell = null

var team := -1

export var is_village = false
export var income = 0

export(Array, Vector2) var neighbors = []

onready var hover_timer := $HoverTimer

onready var flag := $Flag
onready var flag_label := $Flag/Label

func _ready() -> void:
	if is_village:
		flag_label.text = "+%d" % income
		flag.show()

func capture(team, team_color):
	if not is_village:
		return

	self.team = team

	flag.self_modulate = team_color
	emit_signal("captured", team, cell)

func get_danger_level(team):
	var danger_level = 0
	for n_tile in neighbors:
		if n_tile.unit and n_tile.unit.team != team:
			danger_level += 1
	return danger_level

func is_save_for_team(team):
	for n_tile in neighbors:
		if n_tile.unit and n_tile.unit.team != team:
			return false
	return true

func _on_Tile_mouse_entered() -> void:
	hover_timer.start(INFO_DELAY)

func _on_Tile_mouse_exited() -> void:
	hover_timer.stop()
	get_tree().call_group("MatchHUD", "clear_tile_info")

func _on_HoverTimer_timeout() -> void:
	get_tree().call_group("MatchHUD", "update_tile_info", self)
