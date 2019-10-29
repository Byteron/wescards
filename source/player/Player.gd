extends Node

var gold := 0
var actions := 0

var deck := []
var hand := []
var units := []

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

func add_unit(unit):
	units.append(unit)
	unit.connect("died", self, "_on_Unit_died")

func load_deck():
	var files = Loader.load_dir("res://data/cards/", ["tres"])

	for file in files:
		for i in 4:
			deck.append(file.data)

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
	gold += base_income
	actions = 1

func cleanup():
	for unit in units:
		unit.restore()

func _on_Unit_died(unit):
	units.erase(unit)
