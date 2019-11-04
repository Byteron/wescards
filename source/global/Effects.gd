extends Node

func heal(unit, args):
	unit.heal(args.value)
	print(unit, " healt by ", args.value)

func harm(unit, args):
	unit.harm(args.value)
	print(unit, " harmed by ", args.value)

func modify(object, args, remove := false):

	if not args.has("stat"):
		print("no stat defined")
		return

	if not args.has("value"):
		print("no value defined")
		return

	var stat = object.get_node("Stats/" + args.stat)

	if not remove:
		stat.add_bonus(args.value)
		print(stat, " add ", args.value)
	else:
		stat.remove_bonus(args.value)
		print(stat, " remove ", args.value)
