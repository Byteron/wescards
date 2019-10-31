extends Node
class_name AI

signal turn_finished
signal combatting_units_finished
signal moving_units_finished
signal played_card

func make_turn(game, player):
	randomize()
	_combat_units(game, player)
	yield(self, "combatting_units_finished")
	_move_units(game, player)
	yield(self, "moving_units_finished")
	_play_cards(game, player)
	yield(self, "played_card")
	_draw_card(player)
	call_deferred("emit_signal", "turn_finished")

func _combat_units(game, player):
	for unit in player.units:
		var tile = _get_combat_tile(unit, game)
		if tile:
			game.combat(unit, tile.unit)
			yield(get_tree().create_timer(0.5), "timeout")
	call_deferred("emit_signal", "combatting_units_finished")

func _move_units(game, player):
	for unit in player.units:

		if not unit.actions:
			continue

		var tile = _get_move_tile(unit, game)
		if tile:
			game.move_unit(unit, tile)
			yield(game.tween, "tween_completed")
	call_deferred("emit_signal", "moving_units_finished")

func _play_cards(game, player):
	for card in player.hand:
		if card.cost <= player.gold and player.actions > 0:
			var tile = _get_free_castle_tile(player, game)
			if tile:
				game.place_unit(card, tile, tile.rect_global_position)
				yield(get_tree().create_timer(game.ANIMATION_TIME), "timeout")
	call_deferred("emit_signal", "played_card")

func _draw_card(player):
	if player.actions > 0:
		player.draw_card()

func _get_combat_tile(unit, game):
	var tiles = []
	var combat_tiles = []
	var tile = null

	# get all tiles with enemy units
	for n_cell in unit.tile.neighbors:
		var n_tile = game.tiles[unit.tile.cell + n_cell]
		if n_tile.unit and n_tile.unit.team != unit.team:
			tiles.append(n_tile)

	# filter for units that won't kill the attacker
	for tile in tiles:
		if _shall_attack(unit, tile.unit):
			combat_tiles.append(tile)

	# pick random tile
	if combat_tiles:
		tile = combat_tiles[0]
		# pick the weakest or the leader
		for c_tile in combat_tiles:
			# return hero
			if c_tile.unit.is_hero:
				return c_tile
			# set to tile if weaker then previous tile
			if c_tile.unit.health.value < tile.unit.health.value:
				tile = c_tile

	return tile

func _shall_attack(unit1, unit2):
	if unit1.ranged.value > 0:
		return true

	var shall_attack = true
	shall_attack = shall_attack and unit2.melee.value - unit1.defense.value < unit1.health.value
	shall_attack = shall_attack and unit2.melee.value - unit1.defense.value <= unit1.melee.value - unit2.defense.value
	return shall_attack

func _get_move_tile(unit, game):
	var tile = null
	var tiles = []
	var villages = []

	for n_cell in unit.tile.neighbors:
		var n_tile = game.tiles[unit.tile.cell + n_cell]
		if not n_tile.unit:
			tiles.append(n_tile)

	for n_tile in tiles:
		if n_tile.is_village:
			villages.append(n_tile)

	if villages:
		tile = villages[randi() % villages.size()]
	elif tiles:
		tile = tiles[randi() % tiles.size()]

	return tile

func _get_free_castle_tile(player, game):
	for cell in player.castle_tiles:
		var tile = game.tiles[cell]
		if tile.unit == null:
			return tile
	return null
