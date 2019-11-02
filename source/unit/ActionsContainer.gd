extends VBoxContainer

var value := 0 setget _set_value

func _set_value(new_value):
	_clear()
	value = new_value
	for i in value:
		var orb = Orb.instance()
		add_child(orb)

func _clear():
	for child in get_children():
		remove_child(child)
		child.queue_free()
