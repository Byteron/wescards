extends Control

onready var card_container = $CenterContainer/ScrollContainer/GridContainer

func _ready() -> void:
	card_container.columns = Global.cards.size() / 2 + 1

	for card_data in Global.cards.values():
		var card : Card = _get_card_instance(card_data)
		card_container.add_child(card)
		card.team_color = Color("620000")
		card.initialize(card_data)
		card.update_display()

func _get_card_instance(data):
	if data is UnitData:
		return UnitCard.instance()
	elif data is LandData:
		return LandCard.instance()
	elif data is SpellData:
		return SpellCard.instance()
	return Card.instance()
