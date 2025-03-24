extends Path2D

@onready var drop_path_follow: PathFollow2D = $DropPathFollow
@onready var harvestable_resources: HarvestableResources = $DropPathFollow/HarvestableResources
@onready var drop_audio: RandomAudioComponent = %DropAudio


func drop(center_pos: Vector2):
	# 角度
	var dir = Vector2.from_angle(randf_range(0, PI))
	# 距离
	var dis = randf_range(10,20)
	# 落点
	var end_pos = center_pos + dir * dis
	# 控制点
	var ctrl_pos = Vector2(end_pos.x, center_pos.y - 20)
	# 生成路径
	curve = Curve2D.new()
	# 点数量，越多越平滑
	var point_count = 20
	for t in point_count:
		var point = _quadratic_bezier(center_pos, ctrl_pos, end_pos, t * 1.0 / point_count)
		curve.add_point(point)
	# 动画
	var tween = drop_path_follow.create_tween()
	tween.tween_property(drop_path_follow, "progress_ratio", 1.0, 0.8).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(harvestable_resources, "rotation_degrees", randf_range(-120,120), 1.0)
	
	await tween.finished
	harvestable_resources.monitoring = true
	


func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r


func drop_audio_play() -> void:
	drop_audio.play_random()
