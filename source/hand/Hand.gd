extends Control

const CARD_DISTANCE = 160
const ANIMATION_TIME = 0.2

onready var tween = $Tween
onready var cards = $Cards
onready var units = $Units

onready var active_position = $ActivePosition.rect_global_position

var prev_index = 0

var active_card = null
var hovered_card = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB") and not active_card and hovered_card:
		active_card = hovered_card
		active_card.locked = true
		_move_card(active_card, active_position - active_card.rect_pivot_offset, ANIMATION_TIME)

	elif event.is_action_pressed("LMB") and active_card:
		var the_game = get_tree().get_nodes_in_group("Match")[0]
		if the_game.hovered_tile:
			place_unit(active_card, the_game.hovered_tile)

	elif event.is_action_pressed("RMB") and active_card:
		active_card.locked = false
		hovered_card = active_card
		active_card = null
		_on_Card_mouse_exited(hovered_card)

func _ready() -> void:
	var files = Loader.load_dir("res://data/cards/", ["tres"])

	for file in files:
		var card = Card.instance()
		cards.add_child(card)
		card.connect("mouse_entered", self, "_on_Card_mouse_entered", [ card ])
		card.connect("mouse_exited", self, "_on_Card_mouse_exited", [ card ])
		card.initialize(file.data)

	_resize_hand()

func place_unit(card, tile):
	var pos = card.rect_global_position
	cards.remove_child(card)
	units.add_child(card)
	card.make_unit()
	card.rect_global_position = pos

	card.disconnect("mouse_entered", self, "_on_Card_mouse_entered")
	card.disconnect("mouse_exited", self, "_on_Card_mouse_exited")

	tween.interpolate_property(card, "rect_size", card.rect_size, tile.rect_size, ANIMATION_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(card, "rect_pivot_offset", card.rect_pivot_offset, tile.rect_pivot_offset, ANIMATION_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(card, "rect_scale", card.rect_scale, tile.rect_scale, ANIMATION_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

	card.locked = false
	_move_card(card, tile.rect_global_position, ANIMATION_TIME)

	active_card = null
	hovered_card = null
	_resize_hand()

func _resize_hand():
	var x = 0
	for card in cards.get_children():
		card.rect_position.x = x + card.rect_size.x / 2
		card.save_position()
		x -= CARD_DISTANCE

func _on_Card_mouse_entered(card):

	if card.locked or active_card:
		return

	hovered_card = card
	prev_index = card.get_index()
	cards.move_child(card, cards.get_child_count() - 1)
	_move_card(card, card.rect_global_position - card.rect_size * Vector2(0, 0.5), ANIMATION_TIME)

func _on_Card_mouse_exited(card):

	if card.locked or active_card:
		return

	hovered_card = null
	cards.move_child(card, prev_index)
	_move_card(card, card.origin_position, ANIMATION_TIME)

func _move_card(card, target_position, time):

	if not time:
		card.rect_global_position = target_position
		return

	tween.stop(card, "rect_position")
	tween.interpolate_property(card, "rect_global_position", card.rect_global_position, target_position, ANIMATION_TIME, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
