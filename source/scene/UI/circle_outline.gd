extends ColorRect

@export var radius: float = 30
@onready var color_rect: ColorRect = $ColorRect



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if owner:
		await owner.ready
	init_set()


func init_set() -> void:
	size = Vector2(radius*2,radius*2)
	pivot_offset = Vector2(radius,radius)
	color_rect.size = Vector2(radius*2,radius*2)
	color_rect.pivot_offset = Vector2(radius,radius)
	$AnimationPlayer.play("rotate")
