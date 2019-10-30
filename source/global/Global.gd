extends Node

var deck1 = "Humans"
var deck2 = "Orcs"

var cards := {}
var decks := {}

func _ready() -> void:
	_load_cards()
	_load_decks()

func _load_cards():
	var files = Loader.load_dir("res://data/cards/", ["tres"])

	for file in files:
		cards[file.data.id] = file.data

func _load_decks():
	var files = Loader.load_dir("res://data/decks/", ["tres"])

	for file in files:
		decks[file.data.id] = file.data
