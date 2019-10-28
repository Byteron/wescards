extends Button

var card_number := 0 setget _set_card_number

onready var label = $Label

func _ready() -> void:
	_set_card_number(0)

func _set_card_number(number):
	card_number = number
	label.text = "%d" % number
