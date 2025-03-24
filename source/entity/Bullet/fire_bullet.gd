extends Node2D

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var visuals: Node2D = $Visuals
@onready var fire_audio: RandomAudioComponent = $FireAudio
@onready var attack_timer: Timer = $AttackTimer
@onready var collision_shape_2d: CollisionShape2D = $Visuals/HitboxComponent/CollisionShape2D

var current_tween: Tween = null  # 确保此声明在类作用域
var _parent: Node2D



func _ready() -> void:
	animated_sprite.play("idle")
	_parent = get_parent().owner


func _process(delta: float) -> void:
	if _parent.current_target:
		animated_sprite.play("attack")
		# 新方法，可以计算最小角度
		new_rotate(delta)
		
		# 老方法，不能计算最小角度
		#rotate_to_global_position(_parent.current_target.global_position + \
			#_parent.current_target.sprite.offset,0.5)
		if attack_timer.time_left > 0:
			collision_shape_2d.disabled = true
			return
		else:
			collision_shape_2d.disabled = false
			await get_tree().create_timer(0.1).timeout
			attack_timer.start()
		if !fire_audio.playing:
			fire_audio.play_random()

	#if _parent.current_target:
		#test_rotate(delta)


# 新方法，可以计算最小角度
func new_rotate(_delta: float) -> void:
	var target_pos = _parent.current_target.global_position + _parent.current_target.sprite.offset
	var shoot_pos = _parent.shoot_point.global_position
	var target_dir = (target_pos - shoot_pos).normalized()
	
	# 计算目标角度（包含偏移）
	var target_angle = target_dir.angle()
	
	# 计算最短路径差值
	var current_angle = fposmod(rotation, TAU)
	target_angle = fposmod(target_angle, TAU)
	var angle_diff = fposmod(target_angle - current_angle + PI, TAU) - PI
	
	# 插值旋转（确保平滑）
	rotation += angle_diff * min(1.5 * _delta, 1.0)


# 老方法，不能计算最小角度
func rotate_to_global_position(target_global_pos: Vector2, duration: float):
	# 直接转换目标全局坐标到本地坐标系
	var local_dir := to_local(target_global_pos)
	var target_angle := local_dir.angle()
	
	# 停止旧 Tween
	if current_tween != null && current_tween.is_valid():
		current_tween.kill()
	
	#print("目标角度: ", target_angle, " | 当前角度: ", visuals.rotation)
	
	# 直接插值到目标角度（Godot 会自动选择最短路径）
	current_tween = create_tween()
	current_tween.tween_property(visuals, "rotation", target_angle, duration)\
		.set_ease(Tween.EASE_IN_OUT)\
		.set_trans(Tween.TRANS_LINEAR)
	
	await current_tween.finished
