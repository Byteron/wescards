extends Node
class_name Stat

signal stat_changed()

var maximum := 0 setget ,_get_maximum
var value := 0 setget _set_value, _get_value

var bonus := 0

func add_bonus(amount):
	bonus += amount
	value += amount
	emit_signal("stat_changed")

func remove_bonus(amount):
	bonus -= amount
	value = clamp(value - amount, 0, _get_maximum())
	emit_signal("stat_changed")

func reset_bonus():
	bonus = 0
	value = clamp(value, 0, _get_maximum())
	emit_signal("stat_changed")

func restore():
	value = _get_maximum()
	emit_signal("stat_changed")

func deplete_all():
	_set_value(0)
	emit_signal("stat_changed")

func reset():
	value = maximum
	bonus = 0
	emit_signal("stat_changed")

func _set_value(new_value):
	value = clamp(new_value, 0, _get_maximum())
	emit_signal("stat_changed")

func _get_maximum():
	return maximum + bonus

func _get_value():
	return clamp(value, 0, _get_maximum())
