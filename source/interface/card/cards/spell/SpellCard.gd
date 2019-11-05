extends Card
class_name SpellCard

static func instance():
	return load("res://source/interface/card/cards/spell/SpellCard.tscn").instance()

func initialize(card_data, payable = true):
	.initialize(card_data, payable)

func update_display():
	.update_display()
	type.text = "Spell"
