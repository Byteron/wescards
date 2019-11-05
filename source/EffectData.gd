extends Resource
class_name EffectData

enum TYPE { PERSISTENT, TURN_REFRESH, INSTANT }

export(TYPE) var type := TYPE.PERSISTENT

export var curable := false

export var method := ""
export var args := { "value": 0 }
