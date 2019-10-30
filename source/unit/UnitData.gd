extends Resource
class_name UnitData

export var is_hero := false

export var cost := 3
export var melee := 3
export var ranged := 3
export var defense := 0
export var health := 3

export var id := ""
export var alias := ""

export(String, MULTILINE) var description := ""

export var portrait : Texture = null
export var background : Color = Color("666666")
