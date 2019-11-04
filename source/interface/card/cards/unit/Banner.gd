extends ColorRect

const buff_color = Color("00FF00")
const debuff_color = Color("FF0000")

var maximum := 0

var value := 0 setget _set_value
var label_color = Color("FFFFFF") setget _set_label_color

export var colorize = false
export var show_triangle := true

onready var triangle = $Triangle
onready var label = $Label


func _ready() -> void:
	triangle.visible = show_triangle
	label.self_modulate = label_color
	triangle.modulate = color

func _set_value(new_value):
	value = new_value
	label.text = "%d" % value

	if not value:
		hide()
	else:
		show()

	if not colorize:
		return

	if value > maximum:
		label.modulate = buff_color
	elif value < maximum:
		label.modulate = debuff_color
	else:
		label.modulate = Color("FFFFFF")


func _set_label_color(value):
	if not label:
		return
	label.self_modulate = label_color
