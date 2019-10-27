extends Control

onready var tween = $Tween
onready var cards = $Cards

func _ready() -> void:
	for card in cards.get_children():
		card.connect("mouse_entered", self, "_on_Card_mouse_entered", [ card ])
		card.connect("mouse_exited", self, "_on_Card_mouse_exited", [ card ])

	_resize_hand()

func _resize_hand():
	var x = -200 * cards.get_child_count() / 2
	for card in cards.get_children():
		card.rect_position.x = x
		card.save_position()
		x += 200

func _on_Card_mouse_entered(card):
	print("focus: ", card)
	tween.stop(card, "rect_position:y")
	tween.interpolate_property(card, "rect_position:y", card.rect_position.y, card.rect_position.y - card.rect_size.y / 2, 0.3, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func _on_Card_mouse_exited(card):
	print("unfocus: ", card)
	tween.stop(card, "rect_position:y")
	tween.interpolate_property(card, "rect_position:y", card.rect_position.y, card.origin_position.y, 0.3, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
