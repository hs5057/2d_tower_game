extends StaticBody2D
class_name BaseTower

var enemies: Array[BaseEnemy]
var current_target: BaseEnemy = null  # 新增当前目标
var target_pos:Vector2 = Vector2.ZERO
@export var bullet_scene: PackedScene
@export var attack_interval: float # 攻击间隔
@export var attack_range_radius: float # 攻击范围半径
@onready var attack_range: Area2D = $AttackRange
@onready var attack_timer: Timer = %AttackTimer
@onready var bullet_node: Node2D = $BulletNode
@onready var shoot_point: Marker2D = %ShootPoint
@onready var attack_range_collision_shape: CollisionShape2D = %CollisionShape2D
@onready var circle_outline: ColorRect = %CircleOutline
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var state_label: Label = $StateLabel

enum TowerType { NULL, ARROWTOWER, FIRETOWER }
@export var current_tower_type : TowerType

enum State { ATTACK, IDLE, STOP }
var current_state: State = State.IDLE


func _ready() -> void:
	attack_range.body_entered.connect(_on_attack_range_body_entered)
	attack_range.body_exited.connect(_on_attack_range_body_exited)
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	attack_timer.wait_time = attack_interval
	attack_timer.start()
	
	attack_range_collision_shape.shape.radius = attack_range_radius
	circle_outline.visible = false  # 确保初始隐藏
	circle_outline.radius = attack_range_collision_shape.shape.radius
	#print(circle_outline.radius)
	circle_outline.init_set()
	#print(circle_outline.size)
	#print(circle_outline.pivot_offset)
	circle_outline.position = circle_outline.pivot_offset * -1 + sprite_2d.offset


func _process(_delta: float) -> void:
	calculate_recent_enemy()
	
	match current_state:
		State.IDLE:
			state_label.text = "current_state = idle"
			stop_shoot()
		State.ATTACK:
			state_label.text = "current_state = attack"
			shoot()
		State.STOP:
			state_label.text = "current_state = stop"
			return


func stop_shoot() -> void:
	if current_state == State.STOP:
		return
	#print("停止射击")
	for node in bullet_node.get_children():
		node.queue_free()
	attack_timer.stop()
	current_state = State.STOP


func shoot() -> void:
	if current_target == null:
		return
	if attack_timer.time_left > 0:
		return
	attack_timer.start()

	match current_tower_type:
		# 喷火塔
		TowerType.FIRETOWER:
			if bullet_node.get_child_count() <= 0:
				var bullet_instance = bullet_scene.instantiate()
				# 使用 call_deferred 延迟添加子节点
				bullet_node.add_child(bullet_instance)
				bullet_instance.global_position = shoot_point.global_position
				$ShootAudio.play_random()
				#bullet_instance.shoot(target_pos)
				attack_timer.stop
			return
		# 箭塔
		TowerType.ARROWTOWER:
			var bullet_instance = bullet_scene.instantiate()
			# 使用 call_deferred 延迟添加子节点
			bullet_node.add_child(bullet_instance)
			$ShootAudio.play_random()
			bullet_instance.shoot(shoot_point.global_position, target_pos)
			current_state = State.IDLE
		TowerType.NULL:
			return


func calculate_recent_enemy() -> void:
	if enemies.is_empty():
		current_target = null
		current_state = State.IDLE
		return
	
	# 按距离排序
	enemies.sort_custom(func(a, b): 
		return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position)
	)

	# 更新当前目标为最近敌人
	current_target = enemies[0]
	#print("New target: ", current_target.name)
	# 刷新实际目标位置
	target_pos = current_target.global_position + current_target.sprite.offset
	current_state = State.ATTACK


func _on_attack_range_body_entered(body: Node2D) -> void:
	if body is BaseEnemy and body not in enemies:
		enemies.append(body)


func _on_attack_range_body_exited(body: Node2D) -> void:
	if body is BaseEnemy and body in enemies:
		enemies.erase(body)


func _on_attack_timer_timeout() -> void:
	current_state = State.ATTACK


func _on_circle_outline_area_mouse_entered() -> void:
	circle_outline.visible = true


func _on_circle_outline_area_mouse_exited() -> void:
	circle_outline.visible = false
