extends Node2D

const ANIMATION_TIME = 0.2

var hovered_tile = null
var current_player = null setget _set_current_player
var current_unit = null setget _set_current_unit

onready var tween = $Tween
onready var AI = $AI

# Move to separate Board class
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
		if hovered_tile and not current_unit:
			if hovered_tile.unit and hovered_tile.unit.team == current_player.team and hovered_tile.unit.actions > 0:
				_set_current_unit(hovered_tile.unit)
		elif current_unit and current_unit.actions > 0:
			if hovered_tile and current_unit.tile.neighbors.has(hovered_tile.cell - current_unit.tile.cell) and not hovered_tile.unit:
				move_unit(current_unit, hovered_tile, ANIMATION_TIME)
				_set_current_unit(null)
			elif hovered_tile and current_unit.tile.neighbors.has(hovered_tile.cell - current_unit.tile.cell) and hovered_tile.unit:
				if current_unit.team != hovered_tile.unit.team:
					combat(current_unit, hovered_tile.unit)
					_set_current_unit(null)
	elif event.is_action_pressed("RMB"):
		_set_current_unit(null)

func _ready() -> void:
	players.get_children()[0].deck_id = Global.deck1
	players.get_children()[1].deck_id = Global.deck2

	_setup_players()

	for cell in tiles.keys():
		var tile = tiles[cell]
		tile.cell = cell
		tile.connect("mouse_entered", self, "_on_mouse_entered", [tile])
		tile.connect("mouse_exited", self, "_on_mouse_exited", [tile])

	for player in players.get_children():
		place_hero(player)

	_set_current_player(players.get_child(0), true)

# TODO: Move to separate Combat Class
func combat(attacker, defender):
	attacker.actions -= 1
	var ranged_attack = attacker.ranged.value > 0

	if ranged_attack:
		var defender_damage = defender.ranged.value - attacker.defense.value
		defender.hurt(attacker.ranged.value - defender.defense.value)
	else:
		var defender_damage = defender.melee.value
		defender.hurt(attacker.melee.value - defender.defense.value)
		attacker.hurt(defender_damage - attacker.defense.value)

	if attacker.is_dead:
		attacker.kill()

	if defender.is_dead:
		defender.kill()

	if defender.is_dead and not attacker.is_dead and not ranged_attack:
		var defender_tile = defender.tile
		move_unit(attacker, defender_tile, ANIMATION_TIME)

# TODO move to Player
func draw_card():
	current_player.draw_card()
	current_player.actions -= 1

	get_tree().call_group("MatchHUD", "update_player", current_player)

func place_hero(player):
	var hero = Unit.instance()
	hero.data = player.hero_data
	hero.team_color = player.team_color
	hero.team = player.get_index()

	player.add_hero(hero)
	units.add_child(hero)

	var tile = tiles[player.start_position]

	move_unit(hero, tile, 0)

func place_unit(card_data, tile, pos):
	current_player.hand.erase(card_data)
	current_player.gold -= card_data.cost
	current_player.actions -= 1

	get_tree().call_group("MatchHUD", "update_player", current_player)

	var unit = Unit.instance()
	unit.data = card_data
	unit.team_color = current_player.team_color
	unit.team = current_player.get_index()

	current_player.add_unit(unit)
	units.add_child(unit)

	unit.rect_global_position = pos
	unit.rect_size = Vector2(280, 400)

	move_unit(unit, tile, ANIMATION_TIME)

func next_player():
	var index = (current_player.get_index() + 1) % players.get_child_count()
	_set_current_player(players.get_child(index))
	_set_current_unit(null)

func can_place_card():
	return hovered_tile and current_player and current_player.castle_tiles.has(hovered_tile.cell)

# Move to separate Board class
func move_unit(unit, tile, time = ANIMATION_TIME):
	unit.actions -= 1

	if not time:
		unit.rect_global_position = tile.rect_global_position
		unit.rect_size = tile.rect_size
		unit.rect_scale = tile.rect_scale
	else:
		tween.interpolate_property(unit, "rect_size", unit.rect_size, tile.rect_size, ANIMATION_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.interpolate_property(unit, "rect_scale", unit.rect_scale, tile.rect_scale, ANIMATION_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.interpolate_property(unit, "rect_global_position", unit.rect_global_position, tile.rect_global_position, ANIMATION_TIME, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.start()

	if unit.tile:
		unit.tile.unit = null
	tile.unit = unit
	unit.tile = tile

	if tile.is_village:
		current_player.add_village(tile)

	get_tree().call_group("MatchHUD", "update_player", current_player)

# Move to separate Board class
func move_card(card, target_position, time = ANIMATION_TIME):

	if not time:
		card.rect_global_position = target_position
		return

	tween.stop(card, "rect_position")
	tween.interpolate_property(card, "rect_global_position", card.rect_global_position, target_position, ANIMATION_TIME, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func _setup_players():
	for player in players.get_children():
		player.initialize()

func _set_current_player(new_player, first_turn = false):

	for player in players.get_children():
		player.cleanup()

	current_player = new_player

	if not current_player:
		return

	if not first_turn:
		current_player.upkeep()

	if current_player.controller == Player.CONTROLLER.AI:
		AI.make_turn(self, current_player)
		yield(AI, "turn_finished")
		next_player()
	else:
		get_tree().call_group("MatchHUD", "update_player", current_player)

func _set_current_unit(value):
	if current_unit:
		get_tree().call_group("MatchHUD", "clear_reachable")
		current_unit.deselect()

	current_unit = value

	if current_unit:
		current_unit.select()
		get_tree().call_group("MatchHUD", "update_reachable", tiles, current_unit.tile)

func _on_mouse_entered(tile):
	hovered_tile = tile

func _on_mouse_exited(tile):
	hovered_tile = null

#func _draw() -> void:
#	if not tiles:
#		return
#
#	for cell in tiles.keys():
#		var tile = tiles[cell]
#		for n_cell in tile.neighbors:
#			var n_tile = tiles[cell + n_cell]
#			draw_line(tile.rect_global_position + Vector2(100, 100), n_tile.rect_global_position + Vector2(100, 100), Color("FF0000"), 3)
