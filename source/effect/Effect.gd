class_name Effect

var object : Object = null
var property := ""
var operation := ""
var value := 0

func _init(object : Object, property: String, operation: String, value: int) -> void:
	self.object = object
	self.property = property
	self.operation = operation
	self.value = value

func exectute():

	if not object.get(property):
		print(object, "does not have ", property)
		return

	match operation:
		"+":
			object.set(property, object.get(property) + value)
		"-":
			object.set(property, object.get(property) - value)
		"*":
			object.set(property, object.get(property) * value)
		"/":
			object.set(property, object.get(property) / value)
