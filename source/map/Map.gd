extends TileMap
class_name Map

const OFFSET = Vector2(72, 72)

var tiles = {}

func _ready() -> void:
	_initialize_tiles()

func map_to_world_centered(cell):
	return map_to_world(cell) + OFFSET

func world_to_world_centered(world_position):
	return map_to_world_centered(world_to_map(world_position))

func _initialize_tiles():
	for cell in get_used_cells():
		tiles[cell] = {}
