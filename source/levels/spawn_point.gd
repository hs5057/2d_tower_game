extends Marker2D
class_name SpawnPoint

enum SpawnDirection { TOP, RIGHT, BOTTOM, LEFT }
@export var spawn_direction: SpawnDirection = SpawnDirection.TOP


func _ready():
	print("[SpawnPoint]-[%s] 生成点方向：%s | 坐标：%s" % [self.name, spawn_direction, self.global_position])
