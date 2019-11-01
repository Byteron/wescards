extends Card
class_name LandCard

static func instance():
	return load("res://source/interface/card/cards/land/LandCard.tscn").instance()

func initialize(card_data, payable = true):
	.initialize(card_data, payable)

func update_display():
	.update_display()
	type.text = "Land - Shrine"
