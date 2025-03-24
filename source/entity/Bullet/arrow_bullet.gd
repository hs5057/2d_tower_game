extends Path2D

@onready var path_follow: PathFollow2D = %PathFollow2D
@onready var sprite: Sprite2D = %Sprite2D
@onready var collision_shape: CollisionShape2D = %CollisionShape2D


func shoot(start_pos: Vector2, end_pos: Vector2):
	# 清空原有路径
	curve = Curve2D.new()
	
	# 计算相对路径（以防御塔位置为原点）
	var local_end_pos = end_pos - start_pos
	var ctrl_pos = local_end_pos * 0.5 + Vector2(0, -local_end_pos.length() * 0.5)
	
	# 生成路径点（相对坐标）
	for t in 20:
		var progress = t / 19.0  # 修正进度计算
		var point = _quadratic_bezier(Vector2.ZERO, ctrl_pos, local_end_pos, progress)
		curve.add_point(point)
	
	# 设置全局位置
	global_position = start_pos
	# 重置路径跟随器
	path_follow.progress_ratio = 0.0
	# 调整飞行速度（数值越大越慢）
	var flight_time = local_end_pos.length() / 200.0  # 原500改为200
	
	
	# 启动动画
	var tween = path_follow.create_tween()
	tween.tween_property(path_follow, "progress_ratio", 1.0, flight_time)
	await tween.finished
	collision_shape.disabled = false
	await await get_tree().create_timer(0.1).timeout
	collision_shape.disabled = true
	# 停留1秒
	await get_tree().create_timer(1.0).timeout
	
	# 渐隐效果
	var fade_tween = create_tween()
	fade_tween.tween_property(sprite, "modulate:a", 0.0, 0.5)
	await fade_tween.finished
	
	queue_free()



func _draw():
	pass
	#if curve.get_point_count() > 0:
		#for i in curve.get_point_count():
			#draw_circle(curve.get_point_position(i), 3, Color.RED)


func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	return q0.lerp(q1, t)
