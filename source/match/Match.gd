extends Node2D

const ANIMATION_TIME = 0.2

var hovered_tile = null
var current_player setget _set_current_player
var current_unit = null

onready var tween = $Tween

onready var tiles = {
	Vector2(1, 0): $Board/Row0/T1,
	Vector2(0, 1): $Board/Row1/T1,
	Vector2(1, 1): $Board/Row1/T2,
	Vector2(2, 1): $Board/Row1/T3,
	Vector2(0, 2): $Board/Row2/T1,
	Vector2(1, 2): $Board/Row2/T2,
	Vector2(2, 2): $Board/Row2/T3,
	Vector2(0, 3): $Board/Row3/T1,
	Vector2(1, 3): $Board/Row3/T2,
	Vector2(2, 3): $Board/Row3/T3,
	Vector2(1, 4): $Board/Row4/T1
}

onready var players = $Players

onready var units = $Units

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		print("ACTION")
		if hovered_tile and not current_unit:
			if hovered_tile.unit:
				current_unit = hovered_tile.unit
		elif current_unit:
			if hovered_tile and current_unit.tile.neighbors.has(hovered_tile.cell - current_unit.tile.cell) and not hovered_tile.unit:
				_move_unit(current_unit, hovered_tile, ANIMATION_TIME)
				current_unit = null
	elif event.is_action_pressed("RMB"):
		current_unit = null

func _ready() -> void:
	for cell in tiles.keys():
		var tile = tiles[cell]
		tile.cell = cell
		tile.connect("mouse_entered", self, "_on_mouse_entered", [tile])
		tile.connect("mouse_exited", self, "_on_mouse_exited", [tile])

	_set_current_player(players.get_child(0))

func draw_card():
	if not current_player:
		return

	current_player.draw_card()
	get_tree().call_group("MatchHUD", "update_player", current_player)

func place_card(card, tile, pos):
	current_player.hand.erase(card.data)

	var unit = Unit.instance()
	unit.data = card.data
	unit.team_color = card.team_color

	units.add_child(unit)

	unit.rect_global_position = pos
	unit.rect_size = card.rect_size

	card.queue_free()

	_move_unit(unit, tile, ANIMATION_TIME)

func next_player():
	var index = (current_player.get_index() + 1) % players.get_child_count()
	_set_current_player(players.get_child(index))

func can_place_card():
	return hovered_tile and current_player and current_player.castle_tiles.has(hovered_tile.cell)

func _move_unit(unit, tile, time):

	if not time:
		unit.rect_global_position = tile.rect_global_position
		if unit.tile:
			unit.tile.unit = null
		tile.unit = unit
		unit.tile = tile
		return

	if unit.tile:
		unit.tile.unit = null
	tile.unit = unit
	unit.tile = tile

	tween.stop(unit, "rect_size")
	tween.stop(unit, "rect_pivot_offset")
	tween.stop(unit, "rect_scale")
	tween.stop(unit, "rect_global_position")
	tween.interpolate_property(unit, "rect_size", unit.rect_size, tile.rect_size, ANIMATION_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(unit, "rect_scale", unit.rect_scale, tile.rect_scale, ANIMATION_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(unit, "rect_global_position", unit.rect_global_position, tile.rect_global_position, ANIMATION_TIME, Tween.TRANS_SINE, Tween.EASE_IN_OUT)

	tween.start()


func _move_card(card, target_position, time):

	if not time:
		card.rect_global_position = target_position
		return

	tween.stop(card, "rect_position")
	tween.interpolate_property(card, "rect_global_position", card.rect_global_position, target_position, ANIMATION_TIME, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func _set_current_player(new_player):

	if current_player:
		current_player.cleanup()

	current_player = new_player

	if not current_player:
		return

	current_player.upkeep()
	get_tree().call_group("MatchHUD", "update_player", current_player)

func _on_mouse_entered(tile):
	hovered_tile = tile

func _on_mouse_exited(tile):
	hovered_tile = null

func _draw() -> void:
	if not tiles:
		return

	for cell in tiles.keys():
		var tile = tiles[cell]
		for n_cell in tile.neighbors:
			var n_tile = tiles[cell + n_cell]
			draw_line(tile.rect_global_position + Vector2(100, 100), n_tile.rect_global_position + Vector2(100, 100), Color("FF0000"), 3)

