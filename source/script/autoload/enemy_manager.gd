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
	var time_factor = TimeSystem.get_total_game_minutes() * 0.005	# 降低时间因子
	var level_factor = PlayerData.current_level * 0.05				# 降低等级因子
	difficulty_factor = 0.3 + time_factor + level_factor			# 基础值从0.3开始
	print("当前难度因子：", difficulty_factor)
	
	

func spawn_enemies():
	var active_points = _get_active_spawn_points()
	print("active_points:",active_points)
	for point in active_points:
		_spawn_enemies_at_point(point)


func _get_active_spawn_points() -> Array:
	# 根据难度因子决定激活的生成点数量
	var max_points = min(ceil(difficulty_factor), 4)
	var points = get_tree().get_nodes_in_group("SpawnPoint")
	points.shuffle()
	# 修正：slice(0, max_points) 而非 max_points - 1
	var re_points = points.slice(0, max_points)
	print("re_points:",re_points)
	return re_points


func _spawn_enemies_at_point(point: SpawnPoint):
	var direction = point.spawn_direction
	var countdown_ui = _get_countdown_ui(direction)
	
	if countdown_ui == null:
		push_error("倒计时UI节点未找到！方向：", direction)
		return
	
	countdown_ui.start_countdown(15.0, direction)
	await countdown_ui.countdown_finished
	
	# 生成敌人
	var count = base_spawn_data.count_per_point + floor(difficulty_factor)
	var level_min = base_spawn_data.level_range[0] + floor(difficulty_factor / 2)
	var level_max = base_spawn_data.level_range[1] + floor(difficulty_factor)
	
	for i in count:
		var enemy_scene = enemy_scenes[1]
		var enemy = enemy_scene.instantiate()
		print(enemy)
		enemy.level = randi_range(level_min, level_max)
		var enemy_node_layer = get_tree().get_first_node_in_group("EnemyNodeLayer")
		enemy_node_layer.add_child(enemy)
		print("point_global_position:",point.global_position)
		enemy.global_position = point.global_position
		await get_tree().create_timer(1.0).timeout


func _get_countdown_ui(direction: SpawnPoint.SpawnDirection) -> SpawnCountdown:
	var ui_path: String
	match direction:
		SpawnPoint.SpawnDirection.TOP:
			ui_path = "/root/Main/GameUI/Countdowns/TopCountdown"
		SpawnPoint.SpawnDirection.RIGHT:
			ui_path = "/root/Main/GameUI/Countdowns/RightCountdown"
		SpawnPoint.SpawnDirection.BOTTOM:
			ui_path = "/root/Main/GameUI/Countdowns/BottomCountdown"
		SpawnPoint.SpawnDirection.LEFT:
			ui_path = "/root/Main/GameUI/Countdowns/LeftCountdown"
		_:
			push_error("未知的生成方向: ", direction)
			ui_path = "/root/Main/GameUI/Countdowns/TopCountdown"
	
	var ui_node = get_node(ui_path)
	print("[EnemyManager] 绝对路径获取节点：", ui_node)
	return ui_node
