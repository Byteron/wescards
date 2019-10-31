extends CanvasLayer

var tiles = {}

onready var tile_container = $CenterContainer/Tiles

func _ready():
	_initialize_tiles()

func _initialize_tiles():
	# make tiles dict
	for y in tile_container.get_child_count():
		var row = tile_container.get_child(y)
		for x in row.get_child_count():
			var tile = row.get_child(x)
			if not tile is Tile:
				continue
			tiles[Vector2(x, y)] = tile

	# generate connections
	for cell in tiles.keys():
		var tile = tiles[cell]
		tile.neighbors = []
		var neighbors = _get_neighbors(cell)
		for n_cell in neighbors:
			if tiles.has(n_cell):
				var n_tile = tiles[n_cell]
				tile.neighbors.append(n_tile)

func _get_neighbors(cell):
	var neighbors = []
	neighbors.append(Vector2(cell.x, cell.y + 1))
	neighbors.append(Vector2(cell.x, cell.y - 1))
	neighbors.append(Vector2(cell.x + 1, cell.y + 1))
	neighbors.append(Vector2(cell.x + 1, cell.y))
	neighbors.append(Vector2(cell.x + 1, cell.y - 1))
	neighbors.append(Vector2(cell.x - 1, cell.y + 1))
	neighbors.append(Vector2(cell.x - 1, cell.y))
	neighbors.append(Vector2(cell.x - 1, cell.y - 1))
	return neighbors
