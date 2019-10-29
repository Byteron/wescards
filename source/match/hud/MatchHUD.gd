extends CanvasLayer

const CARD_DISTANCE = 160
const ANIMATION_TIME = 0.2

onready var tween = $Tween
onready var hand = $Hand
onready var deck = $Deck

onready var active_position = $ActivePosition.rect_global_position

var player = null

var prev_index = 0

var active_card = null
var hovered_card = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB") and not active_card and hovered_card:
		active_card = hovered_card
		active_card.locked = true
		_move_card(active_card, active_position, ANIMATION_TIME)

	elif event.is_action_pressed("LMB") and active_card:
		var the_game = get_tree().get_nodes_in_group("Match")[0]
		if the_game.can_place_card():
			play_card(active_card, the_game.hovered_tile)

	elif event.is_action_pressed("RMB") and active_card:
		active_card.locked = false
		hovered_card = active_card
		active_card = null
		_on_Card_mouse_exited(hovered_card)

func update_player(new_player):
	clear()
	player = new_player

	deck.card_number = player.deck.size()

	for card_data in player.hand:
		var card = Card.instance()
		card.initialize(card_data)
		hand.add_child(card)
		card.team_color = player.team_color
		card.connect("mouse_entered", self, "_on_Card_mouse_entered", [ card ])
		card.connect("mouse_exited", self, "_on_Card_mouse_exited", [ card ])

	_resize_hand()

func clear():
	for card in hand.get_children():
		hand.remove_child(card)
		card.queue_free()

func play_card(card, tile):
	var pos = card.rect_global_position

	hand.remove_child(card)

	card.disconnect("mouse_entered", self, "_on_Card_mouse_entered")
	card.disconnect("mouse_exited", self, "_on_Card_mouse_exited")

	card.locked = false

	get_tree().call_group("Match", "place_card", card, tile, pos)

	active_card = null
	hovered_card = null
	_resize_hand()

func _resize_hand():
	var x = 0
	for card in hand.get_children():
		card.rect_position.x = x
		card.save_position()

		x += card.rect_size.x

func _on_Card_mouse_entered(card):

	if card.locked or active_card:
		return

	hovered_card = card
	prev_index = card.get_index()
	hand.move_child(card, hand.get_child_count() - 1)
	_move_card(card, card.rect_global_position - card.rect_size * Vector2(0, 0.5), ANIMATION_TIME)

func _on_Card_mouse_exited(card):

	if card.locked or active_card:
		return

	hovered_card = null
	hand.move_child(card, prev_index)
	_move_card(card, card.origin_position, ANIMATION_TIME)

func _move_card(card, target_position, time):

	if not time:
		card.rect_global_position = target_position
		return

	tween.stop(card, "rect_position")
	tween.interpolate_property(card, "rect_global_position", card.rect_global_position, target_position, ANIMATION_TIME, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func _on_Deck_pressed() -> void:

	if hand.get_child_count() >= 3:
		return

	get_tree().call_group("Match", "draw_card")

func _on_EndTurn_pressed() -> void:
	get_tree().call_group("Match", "next_player")
