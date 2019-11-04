extends Node
class_name Stat

var maximum := 0 setget ,_get_maximum
var value := 0 setget _set_value, _get_value

var bonus := 0

func add_bonus(amount):
	bonus += amount
	value += amount

func remove_bonus(amount):
	bonus -= amount
	value = clamp(value, 0, _get_maximum())

func reset_bonus():
	bonus = 0
	value = clamp(value, 0, _get_maximum())

func restore():
	value = _get_maximum()

func deplete_all():
	_set_value(0)

func reset():
	value = maximum
	bonus = 0

func _set_value(new_value):
	value = clamp(new_value, 0, _get_maximum())

func _get_maximum():
	return maximum + bonus

func _get_value():
	return value
