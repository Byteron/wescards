extends Node

func heal(unit, args):
	unit.heal(args.value)
	print(unit, " healt by ", args.value)

func harm(unit, args):
	unit.harm(args.value)
	print(unit, " harmed by ", args.value)

func modify(object, args):

	var node = null

	if args.has("path"):
		node = object.get_node(args.path)
	else:
		node = object

	if not node:
		print(args.path, " does not exist")
		return

	if not node.get(args.property):
		print(node, " does not have ", args.property)
		return

	match args.operation:
		"+":
			node.set(args.property, node.get(args.property) + args.value)
		"-":
			node.set(args.property, node.get(args.property) - args.value)
		"*":
			node.set(args.property, node.get(args.property) * args.value)
		"=":
			node.set(args.property, args.value)
		_:
			return

	print(node, ":", args.property, " modified by ", args.operation, args.value)
