extends Resource
class_name BaseResources

@export var id: int
@export var name: String
@export var texture: Texture
@export var min_drop: int = 1
@export var max_drop: int = 2

enum TYPE_NAME {COIN,WOOD,STONE,BONE,IRONORE,COPPERORE,GOLDORE}
@export var current_type_name: TYPE_NAME
