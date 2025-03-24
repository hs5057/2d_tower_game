extends CharacterBody2D
class_name BaseEnemy

@export var max_move_speed:float = 30.0
@export var attack_interval: float
@export var level: int = 1
@onready var health_component: HealthComponent = %HealthComponent
@onready var hit_flash_component: Node = %HitFlashComponent
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var hurt_box_component: HurtBoxComponent = %HurtBoxComponent
@onready var hitbox_component: HitboxComponent = %HitboxComponent
@onready var floating_text_marker: Marker2D = %FloatingTextMarker
@onready var navigation_agent: NavigationAgent2D = %NavigationAgent2D
@onready var attack_interval_timer: Timer = %AttackIntervalTimer
@onready var sprite: Sprite2D = %Sprite2D
@onready var health_progress_bar: ProgressBar = %HealthProgressBar


enum State {IDLE, RUN, ATTACK, KNOCKBACK}
var current_state: State = State.IDLE
var base_house_node: Node2D
var knockback_velocity: Vector2 = Vector2.ZERO  # 击退速度
var can_attack: bool = false
var is_died: bool = false

# 在类作用域新增变量
var _last_position: Vector2 = Vector2.ZERO
var _stuck_timer: float = 0.0
const STUCK_THRESHOLD: float = 1.0  # 卡顿判定时间（秒）
const STUCK_DISTANCE: float = 5.0   # 卡顿判定移动距离阈值


func _ready() -> void:
	navigation_agent.velocity_computed.connect(_on_navigation_agent_velocity_computed)
	attack_interval_timer.timeout.connect(_on_attack_interval_timer_timeout)
	animation_player.animation_finished.connect(_on_animation_finished)
	hurt_box_component.on_hurt.connect(_on_hurt_box_component_on_hurt)
	health_component.died.connect(_on_health_component_died)
	health_component.health_changed.connect(_on_health_component_health_changed)
	
	update_health_progress_bar(health_component.current_health,health_component.max_health)
	base_house_node = get_tree().get_first_node_in_group("BaseHouse") as Node2D
	call_deferred("setup_navigation_target")  # 延迟初始化
	attack_interval_timer.wait_time = attack_interval
	
	# 初始状态为IDLE并播放动画
	current_state = State.IDLE
	animation_player.play("idle")

	# 新增导航代理参数配置
	navigation_agent.path_max_distance = 10.0  # 路径分段检测距离
	navigation_agent.avoidance_enabled = true  # 启用动态避障
	navigation_agent.avoidance_priority = 1.0  # 避障优先级


func setup_navigation_target():
	if !is_instance_valid(base_house_node):
		return
	if base_house_node:
		# 获取基地的Sprite2D节点（需确认节点路径）
		var base_sprite = base_house_node.get_node("Sprite2D") as Sprite2D
		# 计算贴图半径（考虑缩放）
		var texture_size = base_sprite.texture.get_size()
		var can_attack_range_radius = base_house_node.can_attack_range_collision_shape.shape.get_radius()
		var offset_pos = global_position + sprite.offset
		# 计算方向：基地指向生成点的方向
		var direction = (offset_pos - base_house_node.final_position.global_position).normalized()
		var final_target_position = base_house_node.final_position.global_position + base_sprite.scale + direction * can_attack_range_radius

		# 强制刷新导航路径
		navigation_agent.target_position = final_target_position
		
	attack_interval_timer.wait_time = attack_interval
	
	


func _physics_process(delta: float) -> void:
	if !base_house_node:
		return
	$StateLabel.text = str(current_state)
	if is_died:
		return
	
	# 卡顿检测逻辑（仅在RUN状态生效）
	if current_state == State.RUN:
		var moved_distance = global_position.distance_to(_last_position)
		if moved_distance < STUCK_DISTANCE:
			_stuck_timer += delta
			if _stuck_timer >= STUCK_THRESHOLD:
				# 触发重新计算路径
				setup_navigation_target()
				_stuck_timer = 0.0
		else:
			_stuck_timer = 0.0
		_last_position = global_position
		
		# 检查路径是否有效
		if navigation_agent.is_navigation_finished() || navigation_agent.get_current_navigation_path().is_empty():
			setup_navigation_target()
	
	match current_state:
		State.IDLE:
			# 从IDLE切换到RUN的条件
			if !navigation_agent.is_target_reached():
				current_state = State.RUN
			else:
				if can_attack:
					current_state = State.ATTACK
				else:
					animation_player.play("idle")
		State.RUN:
			# 添加状态保护
			if current_state != State.RUN:
				return
			var current_agent_position = global_position
			var next_path_position = navigation_agent.get_next_path_position()
			var new_velocity = current_agent_position.direction_to(next_path_position) * max_move_speed
			
			if navigation_agent.is_navigation_finished():
				can_attack = true
				current_state = State.ATTACK
			else:
				if navigation_agent.avoidance_enabled:
					navigation_agent.set_velocity(new_velocity)
				else:
					_on_navigation_agent_velocity_computed(new_velocity)
				animation_player.play("run")
				move_and_slide()
		State.ATTACK:
			can_attack = false
			animation_player.play("attack")
			attack_interval_timer.start() # 启动攻击间隔计时器
			await animation_player.animation_finished
			current_state = State.IDLE
			# 攻击期间不移动，等待计时器结束后切换回IDLE
			pass
		State.KNOCKBACK:
			# 击退期间物理处理
			animation_player.play("knockback")
			velocity = knockback_velocity
			move_and_slide()
			knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, delta * 1000)  # 阻力系数


# 击退触发方法
func apply_knockback(direction: Vector2, force: float):
	if direction == Vector2.ZERO:
		direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	if current_state == State.KNOCKBACK:
		return  # 避免重复击退
	
	current_state = State.KNOCKBACK
	knockback_velocity = direction.normalized() * force
	
	# 设置短暂击退时间（示例0.3秒）
	await get_tree().create_timer(0.1).timeout
	_end_knockback()

# 击退结束逻辑
func _end_knockback():
	# 重置导航路径
	navigation_agent.target_position = Vector2(-10000, -10000)  # 强制路径失效
	await get_tree().create_timer(0.1).timeout
	setup_navigation_target()
	
	current_state = State.RUN
	
	knockback_velocity = Vector2.ZERO


func _on_attack_interval_timer_timeout() -> void:
	can_attack = true


func _on_animation_finished(anim_name: String):
	pass


func _on_navigation_agent_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity


func _on_hurt_box_component_on_hurt(_force: float, _direction: Vector2) -> void:
	$HurtAudio.play_random()
	apply_knockback(_direction, _force)


func _on_health_component_died() -> void:
	is_died = true
	hurt_box_component.monitoring = false
	hurt_box_component.monitorable = false
	animation_player.play("died")
	await animation_player.animation_finished
	queue_free()


func update_health_progress_bar(current_health: float, max_health: float) -> void:
	health_progress_bar.max_value = max_health
	health_progress_bar.value = current_health


func _on_health_component_health_changed(current_health: float, max_health: float) -> void:
	update_health_progress_bar(current_health,max_health)
