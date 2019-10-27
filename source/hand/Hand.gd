extends Control

const CARD_DISTANCE = 265
const ANIMATION_TIME = 0.2
onready var tween = $Tween
onready var cards = $Cards

func _ready() -> void:
	var files = Loader.load_dir("res://data/cards/", ["tres"])

	for file in files:
		var card = Card.instance()
		card.connect("mouse_entered", self, "_on_Card_mouse_entered", [ card ])
		card.connect("mouse_exited", self, "_on_Card_mouse_exited", [ card ])
		cards.add_child(card)
		card.initialize(file.data)

	_resize_hand()

func _resize_hand():
	var x = -CARD_DISTANCE * cards.get_child_count() / 2
	for card in cards.get_children():
		card.rect_position.x = x
		card.save_position()
		x += CARD_DISTANCE

func _on_Card_mouse_entered(card):
	print("focus: ", card)
	tween.stop(card, "rect_position:y")
	tween.interpolate_property(card, "rect_position:y", card.rect_position.y, card.rect_position.y - card.rect_size.y / 2, ANIMATION_TIME, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func _on_Card_mouse_exited(card):
	print("unfocus: ", card)
	tween.stop(card, "rect_position:y")
	tween.interpolate_property(card, "rect_position:y", card.rect_position.y, card.origin_position.y, ANIMATION_TIME, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
