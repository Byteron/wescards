extends Node

var gold := 0
var actions := 0

var deck := []
var hand := []
var units := []
var villages := {}

var hero = null
var hero_data = null

var income = 0 setget ,calculate_income

export var deck_id := "Test Deck"

export var start_position := Vector2(0, 0)
export var starting_gold := 5
export var base_income := 2

export var team_color := Color("FF0000")

export(Array, Vector2) var castle_tiles := []

onready var team = get_index()

func _ready() -> void:
	gold = starting_gold
	actions = 1
	load_deck()
	shuffle_deck()
	draw_hand()

func add_hero(unit):
	hero = unit
	units.append(hero)
	hero.connect("died", self, "_on_Hero_died")

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
	var deck_data = Global.decks[deck_id]
	hero_data = Global.cards[deck_data.hero]
	for unit_id in deck_data.cards:
		deck.append(Global.cards[unit_id])

func draw_hand():
	for i in 3:
		draw_card()
		print(hand)

func draw_card():
	if not deck:
		return

	var card = deck.pop_front()
	hand.append(card)

func shuffle_deck():
	randomize()
	deck.shuffle()

func upkeep():
	gold += calculate_income()
	actions = 1

func cleanup():
	for unit in units:
		unit.restore()

func calculate_income():
	var income = base_income
	for village in villages.values():
		income += village.income
	return income

func _on_Unit_died(unit):
	units.erase(unit)

func _on_Hero_died(hero):
	get_tree().reload_current_scene()

func _on_Village_captured(team, cell):
	if team == get_index():
		return
	villages.erase(cell)
