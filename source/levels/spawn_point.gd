extends Marker2D
class_name SpawnPoint

enum SpawnDirection { TOP, RIGHT, BOTTOM, LEFT }
@export var spawn_direction: SpawnDirection = SpawnDirection.TOP


func _ready():
	print("生成点方向：", spawn_direction, " | 坐标：", global_position)
