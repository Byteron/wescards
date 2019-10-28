extends Control

const CARD_DISTANCE = 180
const ANIMATION_TIME = 0.2

onready var tween = $Tween
onready var cards = $Cards

var prev_index = 0
var current_card = null

func _input(event: InputEvent) -> void:
	if event.is_action_released("LMB") and current_card:
		_move_card(current_card, current_card.origin_position, ANIMATION_TIME)

func _process(delta: float) -> void:
	if Input.is_action_pressed("LMB") and current_card:
		_move_card(current_card, get_global_mouse_position() - current_card.rect_pivot_offset, 0)

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
	var x = 0
	for card in cards.get_children():
		card.rect_position.x = x + card.rect_size.x / 2
		card.save_position()
		x -= CARD_DISTANCE

func _on_Card_mouse_entered(card):
	current_card = card
	prev_index = card.get_index()
	print("focus: ", card, " moved to ", prev_index)
	cards.move_child(card, cards.get_child_count() - 1)
	_move_card(card, card.rect_global_position - card.rect_size * Vector2(0, 0.5), ANIMATION_TIME)

func _on_Card_mouse_exited(card):
	current_card = null
	print("unfocus: ", card, " moved to ", prev_index)
	cards.move_child(card, prev_index)
	_move_card(card, card.origin_position, ANIMATION_TIME)

func _move_card(card, target_position, time):
	if not time:
		card.rect_global_position = target_position
		return

	tween.stop(card, "rect_position")
	tween.interpolate_property(card, "rect_global_position", card.rect_global_position, target_position, ANIMATION_TIME, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
