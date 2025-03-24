# EnemyManager.gd
extends Node

# 敌人场景映射表（后续可扩展）
var enemy_scenes = {
	1: preload("res://source/entity/enemy/brown_mouse.tscn")  # 默认1级敌人
}

# 基础生成参数
var base_spawn_data = {
	"count_per_point": 1,     # 每个生成点的敌人数
	"level_range": [1, 1],    # 初始等级范围
	"interval": 10.0          # 生成间隔（秒）
}

# 游戏难度因子（随时间、等级增长）
var difficulty_factor: float = 0.0
var difficulty_timer: Timer  # 新增计时器变量


func _ready():
	# 初始化难度计时器
	difficulty_timer = Timer.new()
	difficulty_timer.wait_time = 10.0
	difficulty_timer.autostart = true
	difficulty_timer.timeout.connect(update_difficulty)
	add_child(difficulty_timer)


func update_difficulty():
	# 难度因子 = 基础值 + 时间因子 + 等级因子
	var time_factor = TimeSystem.get_total_game_minutes() * 0.01  # 每分钟增加0.01
	var level_factor = PlayerData.current_level * 0.1              # 每级增加0.1
	difficulty_factor = 0.5 + time_factor + level_factor


func spawn_enemies():
	var active_points = _get_active_spawn_points()
	for point in active_points:
		_spawn_enemies_at_point(point)


func _get_active_spawn_points() -> Array:
	# 根据难度因子决定激活的生成点数量
	var max_points = min(ceil(difficulty_factor), 4)  # 最多4个方向
	var points = get_tree().get_nodes_in_group("SpawnPoint")
	points.shuffle()
	return points.slice(0, max_points - 1)


func _spawn_enemies_at_point(point: SpawnPoint):
	# 获取生成点的方向
	var direction = point.spawn_direction
	
	# 显示对应方向的倒计时UI
	var countdown_ui = _get_countdown_ui(direction)
	countdown_ui.start_countdown(3.0, direction)  # 传递两个参数
	await countdown_ui.countdown_finished
	
	# 生成敌人
	var count = base_spawn_data.count_per_point + floor(difficulty_factor)
	var level_min = base_spawn_data.level_range[0] + floor(difficulty_factor / 2)
	var level_max = base_spawn_data.level_range[1] + floor(difficulty_factor)
	
	for i in count:
		var enemy_scene = enemy_scenes[1]
		var enemy = enemy_scene.instantiate()
		enemy.level = randi_range(level_min, level_max)
		enemy.global_position = point.global_position
		get_tree().current_scene.add_child(enemy)


func _get_countdown_ui(direction: SpawnPoint.SpawnDirection) -> SpawnCountdown:
	match direction:
		SpawnPoint.SpawnDirection.TOP:
			return %TopCountdown
		SpawnPoint.SpawnDirection.RIGHT:
			return %RightCountdown
		SpawnPoint.SpawnDirection.BOTTOM:
			return %BottomCountdown
		SpawnPoint.SpawnDirection.LEFT:
			return %LeftCountdown
		_:
			push_error("未知的生成方向: ", direction)
			return %TopCountdown  # 默认返回顶部倒计时
