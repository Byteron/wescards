extends CardData
class_name LandData

enum TYPE { PERSISTENT, TURN_REFRESH }

export(TYPE) var type := TYPE.PERSISTENT
export var effect : Resource = null
