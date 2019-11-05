extends Node
class_name Player

enum CONTROLLER { PLAYER, AI }

var gold := 0

var deck := []
var hand := []
var lands := []
var units := []
var villages := {}

var hero = null
var hero_data = null

var income = 0 setget ,calculate_income

export(CONTROLLER) var controller = CONTROLLER.PLAYER

export var deck_id := "Test Deck"

export var hand_size := 4
export var max_actions := 1
export var start_position := Vector2(0, 0)
export var starting_gold := 5
export var base_income := 2

export var team_color := Color("FF0000")

onready var team = get_index()

func _ready() -> void:
	pass

func initialize():
	gold = starting_gold
	load_deck()
	shuffle_deck()
	draw_hand()

func add_hero(unit):
	hero = unit
	units.append(hero)
	hero.connect("died", self, "_on_Hero_died")

func add_land(land):
	lands.append(land)
	land.connect("destroyed", self, "_on_Land_destroyed")

func add_unit(unit):
	units.append(unit)
	unit.connect("died", self, "_on_Unit_died")

func add_village(tile):
	if villages.has(tile.cell):
		return

	villages[tile.cell] = tile
	tile.connect("captured", self, "_on_Village_captured")
	tile.capture(get_index(), team_color)

func load_deck():
	if deck_id == "Random":
		randomize()
		deck_id = Global.decks.keys()[randi() % Global.decks.size()]

	var deck_data = Global.decks[deck_id]
	hero_data = Global.cards[deck_data.hero]
	for unit_id in deck_data.cards:
		deck.append(Global.cards[unit_id])

func draw_hand():
	for i in hand_size - hand.size():
		draw_card()

func draw_card():
	if not deck:
		return

	var card = deck.pop_front()
	hand.append(card)

func shuffle_deck():
	randomize()
	deck.shuffle()

func get_summon_tiles():
	var summon_tiles = hero.tile.neighbors.duplicate()
	summon_tiles.append(hero.tile)
	return summon_tiles

func get_nonland_tiles():
	var tiles = []
	for tile in hero.tile.neighbors:
		if not tile.land:
			if tile.unit and tile.unit.team != team:
				continue
			tiles.append(tile)
	return tiles

func upkeep():
	gold += calculate_income()
	draw_hand()

	for land in lands:
		if land.data.effect.type == EffectData.TYPE.TURN_REFRESH:
			land.apply_effect()

	for unit in units:
		unit.rest()
		unit.restore()

func cleanup():
	for unit in units:
		unit.cleanup()

func calculate_income():
	var income = base_income
	for village in villages.values():
		income += village.income
	return income

func _on_Unit_died(unit):
	units.erase(unit)

func _on_Hero_died(hero):
	get_tree().reload_current_scene()

func _on_Land_destroyed(land):
	lands.erase(land)

func _on_Village_captured(team, cell):
	if team == get_index():
		return

	var tile = villages[cell]
	tile.disconnect("captured", self, "_on_Village_captured")
	villages.erase(cell)
