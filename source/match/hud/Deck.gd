extends Button

var card_number := 0 setget _set_card_number

onready var label = $Label
onready var greyscale := $Greyscale

var greyed = false setget _set_greyed

func _ready() -> void:
	_set_card_number(0)

func _set_card_number(number):
	card_number = number
	label.text = "%d" % number

func _set_greyed(value):
	greyed = value
	greyscale.visible = greyed
