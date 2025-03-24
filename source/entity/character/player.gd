extends CharacterBody2D
class_name Player

const AXE = preload("res://source/entity/weapons/axe.tscn")
const PICKAXE = preload("res://source/entity/weapons/pickaxe.tscn")
const MAX_SPEED = 50.0
const ACCELERATION_SMOOTHING = 25
var last_move_sign = 1  # 新增变量记录最后方向

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visuals: Node2D = $Visuals
@onready var weapons: Node2D = %Weapons
@onready var player_pick_up_area: Area2D = %PlayerPickUpArea
@onready var point_light: PointLight2D = $PointLight2D2
@onready var walk_audio: RandomAudioComponent = $WalkAudio


var weapon : BaseWeapon
var is_attacking: bool = false
var tween:Tween = create_tween()


func _ready() -> void:
	walk_audio.stop()
	weapon = weapons.get_child(0)
	player_pick_up_area.area_entered.connect(_on_player_pick_up_area_area_entered)
	player_pick_up_area.area_exited.connect(_on_player_pick_up_area_area_exited)
	PlayerSignal.current_weapon_changed.connect(_on_current_weapon_changed)


func _process(delta: float) -> void:
	if is_attacking:
		animation_player.play("attack")
		velocity = Vector2.ZERO
		return
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	var target_velocity = direction * MAX_SPEED
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	
	move_and_slide()
	
	if movement_vector.x != 0 || movement_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("idle")
	
	var move_sign = sign(movement_vector.x)
	
	if move_sign == 0:
		# 无输入时，使用最后一次记录的方向
		visuals.scale = Vector2(last_move_sign, 1)
		weapons.get_child(0).scale = Vector2(last_move_sign, 1)
	else:
		# 有输入时更新方向
		visuals.scale = Vector2(move_sign, 1)
		weapons.get_child(0).scale = Vector2(move_sign, 1)
		last_move_sign = move_sign  # 记录当前方向


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		is_attacking = true
		weapons.get_child(0).anim_play("attack")
		await weapons.get_child(0).animation_player.animation_finished
		is_attacking = false


# 获取移动向量
func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)


# 拾取函数
func pick_up(_area: Area2D) -> void:
	pass


# 切换武器
func change_weapon(weapon_name: String) -> void:
	if weapon_name == weapons.get_child(0).name:
		return
	for node in weapons.get_children():
		node.queue_free()
	if weapon_name == "Axe":
		var axe = AXE.instantiate()
		weapons.add_child(axe)
		
	elif weapon_name == "Pickaxe":
		var pickaxe = PICKAXE.instantiate()
		weapons.add_child(pickaxe)

	# 使用延迟模式调用该 Callable 所代表的方法，即在当前帧的末尾调用。
	Callable(set_weapon).call_deferred()


# 切换武器以后，需要重新设置变量weapon
func set_weapon() -> void:
	weapon = null
	weapon = weapons.get_child(0)


func _on_player_pick_up_area_area_entered(area: Area2D) -> void:
	var target = area.owner
	if !target:
		return
	if target.is_in_group("HarvestableResources"):
		pick_up(area)
	
	if target.is_in_group("BaseHouse"):
		#point_light_2d.range_item_cull_mask = (1 << 1) | (1 << 4)   # 检测层 2 和 5
		#print("进入：",point_light_2d.range_item_cull_mask)
		#var tween:Tween = create_tween()
		# 停止旧 Tween
		if tween != null && tween.is_valid():
			tween.kill()
		tween = create_tween()
		tween.tween_property(point_light, "energy", 0.2, 0.35)
		#print("进入")


func _on_player_pick_up_area_area_exited(area: Area2D) -> void:
	var target = area.owner
	if !target:
		return
	
	if target.is_in_group("BaseHouse"):
		#print(point_light_2d.get_item_cull_mask())
		#point_light_2d.range_item_cull_mask = (1 << 0) | (1 << 1) | (1 << 4)   # 检测层1 、 2 、 5
		#print("离开：",point_light_2d.range_item_cull_mask)
		#var tween:Tween = create_tween()
		if tween != null && tween.is_valid():
			tween.kill()
		tween = create_tween()
		tween.tween_property(point_light, "energy", 1, 2.0)
		#print("离开")


func _on_current_weapon_changed(weapon_name: String) -> void:
	change_weapon(weapon_name)
