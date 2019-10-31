extends Control
class_name PopupLabel

static func instance():
	return load("res://source/interface/PopupLabel.tscn").instance()

var value = 0
var color = Color("FFFFFF")

onready var tween := $Tween
onready var label := $Label

func _ready() -> void:
	label.text = "%d" % value
	modulate = color

	tween.interpolate_property(self, "rect_scale", Vector2(0, 0), Vector2(1, 1), 0.2, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.interpolate_property(self, "rect_global_position:y", rect_global_position.y, rect_global_position.y - 100, 0.6, Tween.TRANS_SINE, Tween.EASE_OUT, 0.2)
	tween.interpolate_property(self, "modulate:a", modulate.a, 0, 0.4, Tween.TRANS_SINE, Tween.EASE_OUT, 0.4)
	tween.start()

func _on_Tween_tween_all_completed() -> void:
	queue_free()
