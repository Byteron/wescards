extends Control
class_name Unit

const COLOR_GOLD = Color("ebca15")

static func instance():
	return load("res://source/unit/Unit.tscn").instance()

signal died(unit)

# var max_actions := 0
# var actions := 0 setget _set_actions

var data = null
var tile = null

var team = 0
var team_color = Color("FFFFFF")

var rest := 2

var is_hero = false
var is_dead = false


onready var tween := $Tween

onready var portrait := $MarginContainer/MarginContainer/VBoxContainer/Portrait/Image
onready var portrait_vignette := $MarginContainer/MarginContainer/VBoxContainer/Portrait/Vignette
onready var back := $MarginContainer/Background
onready var border := $MarginContainer/Border

onready var actions := $Stats/Actions as Stat setget _set_actions, _get_actions
onready var ranged := $Stats/Ranged as Stat
onready var melee := $Stats/Melee as Stat
onready var armor := $Stats/Armor as Stat
onready var health := $Stats/Health as Stat

onready var melee_banner := $MarginContainer/MarginContainer/VBoxContainer/Portrait/HBoxContainer/HBoxContainer/Melee
onready var ranged_banner := $MarginContainer/MarginContainer/VBoxContainer/Portrait/HBoxContainer/HBoxContainer/Ranged
onready var armor_banner := $MarginContainer/MarginContainer/VBoxContainer/Portrait/HBoxContainer/Armor
onready var health_banner := $MarginContainer/MarginContainer/VBoxContainer/Portrait/HBoxContainer/Health

onready var actions_container := $MarginContainer/MarginContainer/Actions/ActionsContainer

onready var greyscale := $MarginContainer/MarginContainer/VBoxContainer/Portrait/Greyscale

func _ready() -> void:
	propagate_call("set_mouse_filter", [ Control.MOUSE_FILTER_IGNORE ])

	for stat in $Stats.get_children():
		stat.connect("stat_changed", self, "_on_Stat_stat_changed")

func initialize(unit_data):
	is_hero = unit_data.is_hero

	actions.maximum = unit_data.actions
	melee.maximum = unit_data.health
	ranged.maximum = unit_data.ranged
	melee.maximum = unit_data.melee
	armor.maximum = unit_data.armor
	health.maximum = unit_data.health

	melee_banner.maximum = melee.maximum
	ranged_banner.maximum = ranged.maximum
	armor_banner.maximum = armor.maximum
	health_banner.maximum = health.maximum

	portrait.texture = unit_data.image
	back.color = unit_data.tint

	if is_hero:
		portrait.get_node("../Overlay").self_modulate = COLOR_GOLD
		portrait_vignette.self_modulate = COLOR_GOLD
	reset()

func update_display():

	actions_container.value = actions.value

	if actions.value:
		greyscale.visible = false
	else:
		greyscale.visible = true

	melee_banner.value = melee.value
	ranged_banner.value = ranged.value
	armor_banner.value = armor.value
	health_banner.value = health.value

	border.self_modulate = team_color

func harm(damage):
	if not damage:
		return

	health.value -= damage

	var popup = PopupLabel.instance()
	popup.value = damage
	popup.color = Color("FF0000")
	popup.rect_global_position = rect_global_position + rect_pivot_offset
	get_tree().current_scene.add_child(popup)

	if health.value == 0:
		is_dead = true


func heal(value):
	var diff = clamp(health.value + value, 0, health.maximum) - health.value
	health.value = clamp(health.value + value, 0, health.maximum)

	if not diff:
		return

	var popup = PopupLabel.instance()
	popup.value = diff
	popup.color = Color("00FF00")
	popup.rect_global_position = rect_global_position + rect_pivot_offset
	get_tree().current_scene.add_child(popup)

func kill():
	tile.unit = null
	emit_signal("died", self)
	queue_free()

func select():
	tween.stop_all()
	tween.interpolate_property(portrait_vignette, "self_modulate", portrait_vignette.self_modulate, Color("FFFFFFFF"), 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(portrait, "rect_scale", Vector2(1, 1), Vector2(1.25, 1.25), 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func deselect():
	tween.stop_all()
	if is_hero:
		tween.interpolate_property(portrait_vignette, "self_modulate", portrait_vignette.self_modulate, COLOR_GOLD, 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	else:
		tween.interpolate_property(portrait_vignette, "self_modulate", portrait_vignette.self_modulate, Color("FF000000"), 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(portrait, "rect_scale", Vector2(1.25, 1.25), Vector2(1, 1), 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func rest():
	if actions.value and is_damaged():
		heal(rest)

func reset():
	for stat in [actions, ranged, melee, armor, health]:
		stat.reset()

func restore():
	actions.restore()

func cleanup():
	pass

func is_damaged():
	return health_banner.value < health.maximum

func _set_actions(value):
	actions.value = value

func _get_actions():
	return actions.value

func _on_Stat_stat_changed():
	update_display()
