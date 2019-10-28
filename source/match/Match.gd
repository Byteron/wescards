extends Node2D

var hovered_tile = null

onready var tiles = {
	Vector2(0, 0): $Board/Row1/T1,
	Vector2(1, 0): $Board/Row1/T2,
	Vector2(2, 0): $Board/Row1/T3,
	Vector2(0, 1): $Board/Row2/T1,
	Vector2(1, 1): $Board/Row2/T2,
	Vector2(2, 1): $Board/Row2/T3,
	Vector2(0, 2): $Board/Row3/T1,
	Vector2(1, 2): $Board/Row3/T2,
	Vector2(2, 2): $Board/Row3/T3
}

onready var units = $Board/Units

func _ready() -> void:
	for tile in tiles.values():
		tile.connect("mouse_entered", self, "_on_mouse_entered", [tile])
		tile.connect("mouse_exited", self, "_on_mouse_exited", [tile])

func place_unit(card):
	if hovered_tile:
		hovered_tile.unit = card
		get_tree().call_group("Hand", "placement_successful")

func _on_mouse_entered(tile):
	hovered_tile = tile

func _on_mouse_exited(tile):
	hovered_tile = null

func _draw() -> void:
	if not tiles:
		return

	for cell in tiles.keys():
		var tile = tiles[cell]
		for n_cell in tile.neighbors:
			var n_tile = tiles[n_cell]
			draw_line(tile.rect_global_position + Vector2(100, 100), n_tile.rect_global_position + Vector2(100, 100), Color("FF0000"), 3)

