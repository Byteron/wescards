extends Resource
class_name EffectData

enum TARGET { SELF, ENEMY, ALLY }

export(TARGET) var target := TARGET.SELF
export var property := ""
export var operation := ""
export var value := 0
