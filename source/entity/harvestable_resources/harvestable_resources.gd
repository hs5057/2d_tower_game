@tool
extends Area2D
class_name HarvestableResources

@export var resources: BaseResources
@export var scale_vector2: Vector2
@onready var sprite: Sprite2D = %Sprite2D
@onready var pickup_audio: RandomAudioComponent = $PickupAudio
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var drop_count: int


func _ready() -> void:
	# 检查 resources 和 texture 是否有效
	if resources and resources.texture:
		sprite.texture = resources.texture
		drop_count = randi_range(resources.min_drop, resources.max_drop)
	else:
		push_warning("Resources or texture is not set!")
	area_entered.connect(_on_area_entered)


func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("Player")
	if player == null:
		return
	
	# 全局位置等于起始位置(采集前经验球的位置)	到玩家点的全局位置
	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start = player.global_position - start_position
	
	# 旋转经验球,更平滑的旋转
	var target_rotation = direction_from_start.angle() + rad_to_deg(90)
	rotation = lerp_angle(rotation, target_rotation, 1 - exp(-2 * get_process_delta_time()))


# 解决刚进去就离开拾取范围时，会出现经验球动了一下，又不动了的情况
func disable_collision():
	collision_shape_2d.disabled = true


func collect():
	match resources.current_type_name:
		resources.TYPE_NAME.COIN:
			PlayerData.current_coin += 1
		resources.TYPE_NAME.WOOD:
			PlayerData.current_wood += 1
		resources.TYPE_NAME.STONE:
			PlayerData.current_stone += 1
		resources.TYPE_NAME.IRONORE:
			PlayerData.current_iron_ore += 1
		resources.TYPE_NAME.COPPERORE:
			PlayerData.current_copper_ore += 1
		resources.TYPE_NAME.GOLDORE:
			PlayerData.current_gold_ore += 1
			
	queue_free()




func _on_area_entered(_area: Area2D) -> void:
	# 调用这个方法，但是在下一个空闲帧时调用
	Callable(disable_collision).call_deferred()
	

	var tween = create_tween()
	# 如果 parallel 为 true，那么在这个方法之后追加的 Tweener 将默认同时执行，而不是顺序执行。
	tween.set_parallel()
	
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, .7)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_QUINT)
	
	# .set_delay(0.65) 表示前面花0.05秒执行以后等待0.65秒，和并行的0.7秒同步后，再清除
	tween.tween_property(sprite, "scale", Vector2(0.65, 0.65), 0.05).set_delay(0.65)
	
	# .chain()用于在使用 true 调用 set_parallel() 后，将两个 Tweener 串联。
	tween.chain()
	
	tween.tween_callback(collect)
	
	# 播放拾取音效
	pickup_audio.play_random()
