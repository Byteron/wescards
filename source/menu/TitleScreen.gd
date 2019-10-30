extends Control

onready var you_option := $CenterContainer/VBoxContainer/Player1/OptionButton
onready var enemy_option := $CenterContainer/VBoxContainer/Player2/OptionButton

func _ready() -> void:
	you_option.add_item("Random", 0)
	enemy_option.add_item("Random", 0)

	var idx = 1
	for deck in Global.decks.keys():
		you_option.add_item(deck, idx)
		enemy_option.add_item(deck, idx)
		idx += 1

func _on_Play_pressed() -> void:
	var deck1 = you_option.get_item_text(you_option.get_selected_id())
	var deck2 = enemy_option.get_item_text(enemy_option.get_selected_id())

	Global.deck1 = deck1
	Global.deck2 = deck2

	get_tree().change_scene("res://source/match/Match.tscn")

	# print("%s vs. %s" % [deck1, deck2])
