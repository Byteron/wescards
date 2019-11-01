extends Card
class_name UnitCard

onready var melee := $MarginContainer/VBoxContainer/Stats/Melee
onready var ranged := $MarginContainer/VBoxContainer/Stats/Ranged
onready var defense := $MarginContainer/VBoxContainer/Stats/Defense
onready var health := $MarginContainer/VBoxContainer/Stats/Health

onready var ranged_separator = $MarginContainer/VBoxContainer/Stats/Separator2
onready var defense_separator = $MarginContainer/VBoxContainer/Stats/Separator3

static func instance():
	return load("res://source/interface/card/cards/unit/UnitCard.tscn").instance()

func update_display():
	.update_display()

	melee.value = data.melee
	ranged.value = data.ranged
	ranged_separator.visible = ranged.visible
	defense.value = data.defense
	# defense_separator.visible = defense.visible
	health.value = data.health
