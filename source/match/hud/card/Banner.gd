extends ColorRect

var value := 0 setget _set_value

onready var triangle = $Triangle
onready var label = $Label

func _ready() -> void:
	triangle.color = color

func _set_value(new_value):
	value = new_value
	label.text = "%d" % value

	if not value:
		hide()
	else:
		show()
