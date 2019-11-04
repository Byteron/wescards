extends Card
class_name UnitCard

onready var melee := $MarginContainer/VBoxContainer/Stats/Melee
onready var ranged := $MarginContainer/VBoxContainer/Stats/Ranged
onready var armor := $MarginContainer/VBoxContainer/Stats/Armor
onready var health := $MarginContainer/VBoxContainer/Stats/Health

onready var ranged_separator = $MarginContainer/VBoxContainer/Stats/Separator2
onready var armor_separator = $MarginContainer/VBoxContainer/Stats/Separator3

static func instance():
	return load("res://source/interface/card/cards/unit/UnitCard.tscn").instance()

func update_display():
	.update_display()

	melee.value = data.melee
	ranged.value = data.ranged
	ranged_separator.visible = ranged.visible
	armor.value = data.armor
	# armor_separator.visible = armor.visible
	health.value = data.health
