extends Node
class_name AI

signal action_taken
signal cards_played
signal turn_finished

func get_actions_dict():
	return {
		"move": { "value": 0, "tile": null},
		"combat": { "value": 0, "unit": null},
		"retreat": { "value": 0, "tile": null},
		"rest": { "value": 2 },
	}

func make_turn(game, player):
	randomize()

	# move units
	for unit in player.units:
		for i in unit.actions:
			if not unit.actions:
				continue
			var actions = get_actions_dict()
			_evaluate_retreat(unit, actions)
			_evaluate_combat(unit, actions)
			_evaluate_move(unit, actions)
			call_deferred("_take_action", game, unit, actions)
			yield(self, "action_taken")

	_play_cards(game, player)
	yield(self, "cards_played")

	emit_signal("turn_finished")

func _evaluate_retreat(unit, actions):
	# if not badly hurt, don't retreat
	if unit.health.value > unit.health.maximum / 2:
		return

	#otherwise
	# if already save, rest
	if unit.tile.is_save_for_team(unit.team):
		actions.rest.value += 10
		# if not save, move to other tile
	else:
		var n_tile = _get_savest_tile(unit)

		# check if there is saver tile, if so, move, if not, rest
		if not n_tile or n_tile.get_danger_level(unit.team) >= unit.tile.get_danger_level(unit.team):
			actions.rest.value += 10
		else:
			actions.retreat.value += 12
			actions.retreat.tile = n_tile

func _get_savest_tile(unit):
	var free_tiles := []

	for n_tile in unit.tile.neighbors:
		if not n_tile.unit:
			free_tiles.append(n_tile)

	if not free_tiles:
		return null

	var save_tile = free_tiles[randi() % free_tiles.size()]

	for f_tile in free_tiles:
		if f_tile.is_save_for_team(unit.team):
			return f_tile
		elif f_tile.get_danger_level(unit.team) < save_tile.get_danger_level(unit.team):
			save_tile = f_tile

	return save_tile

func _evaluate_combat(unit, actions):
	var combat_tiles := []
	for n_tile in unit.tile.neighbors:
		if n_tile.unit and n_tile.unit.team != unit.team:
			combat_tiles.append(n_tile)

	if not combat_tiles:
		return

	actions["combat"].value = 8
	actions["combat"].unit = combat_tiles[randi() % combat_tiles.size()].unit

func _evaluate_move(unit, actions):
	var move_tiles := []
	var village_tiles := []

	for n_tile in unit.tile.neighbors:
		if not n_tile.unit and n_tile.get_danger_level(unit.team):
			move_tiles.append(n_tile)

	for m_tile in move_tiles:
		if m_tile.is_village:
			village_tiles.append(m_tile)

	if village_tiles:
		actions["move"].value = 9
		actions["move"].tile = village_tiles[randi() % village_tiles.size()]
		return

	if move_tiles:
		actions["move"].value = 6
		actions["move"].tile = move_tiles[randi() % move_tiles.size()]


func _take_action(game, unit, actions: Dictionary):
	var a_key = "rest"

	# get best action
	for key in actions.keys():
		if actions[a_key].value < actions[key].value:
			a_key = key

	match a_key:
		"retreat":
			game.move_unit(unit, actions["retreat"].tile)
			yield(game.tween, "tween_all_completed")
		"move":
			game.move_unit(unit, actions["move"].tile)
			yield(game.tween, "tween_all_completed")
		"combat":
			game.combat(unit, actions["combat"].unit)
			yield(game, "combat_finished")
		"rest":
			pass

	call_deferred("emit_signal", "action_taken")

func _play_cards(game, player):
	for card in player.hand:
		if card.cost <= player.gold:
			var tile = null
			if card is UnitData:
				tile = _get_free_castle_tile(player)
			elif card is LandData:
				tile = _get_free_nonland_tile(player)
			if tile:
				if card is UnitData:
					game.place_unit(card, tile, tile.rect_global_position)
				elif card is LandData:
					game.place_land(card, tile, tile.rect_global_position)

				yield(get_tree().create_timer(game.ANIMATION_TIME), "timeout")
	call_deferred("emit_signal", "cards_played")

func _get_free_nonland_tile(player):
	for tile in player.get_summon_tiles():
		if not tile.land:
			if tile.unit and tile.unit.team != player.team:
				continue
			return tile
	return null

func _get_free_castle_tile(player):
	for tile in player.get_summon_tiles():
		if not tile.unit:
			return tile
	return null
