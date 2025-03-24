extends Area2D
class_name HurtBoxComponent

const FLOATING_TEXT = preload("res://source/scene/UI/floating_text.tscn")  # 伤害飘字
@export var health_component: Node  # 健康组件
@export var HurtIntervalTimer: float = 0.1 # 受伤间隔
@export var hitbox_name: Array[String]
@onready var hurt_interval_timer: Timer = $HurtIntervalTimer

var is_invincible: bool = false  # 是否处于无敌

signal on_hurt(damage: float, direction: Vector2) # 受伤信号


func _ready() -> void:
	hurt_interval_timer.wait_time = HurtIntervalTimer
	hurt_interval_timer.timeout.connect(_on_hurt_interval_timer_timeout)
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if !area is HitboxComponent:
		return
	var _hitbox_name: String = area.hitbox_name
	
	# 不处于无敌状态时
	if !is_invincible and hitbox_name.has(_hitbox_name):
		is_invincible = true
		var hitbox_component = area as HitboxComponent
		
		# 新增：计算攻击者方向 -------------------------------------------------
		var attacker_pos = area.owner.global_position
		var victim_pos = owner.global_position
		var direction = (victim_pos - attacker_pos).normalized()
		# ---------------------------------------------------------------------
		
		health_component.damage(hitbox_component.damage)
		
		# 显示伤害飘字效果
		var floating_text_instance = FLOATING_TEXT.instantiate() as Node2D
		var foreground_layer = get_tree().get_first_node_in_group("ForegroundLayer")
		foreground_layer.add_child(floating_text_instance)
		floating_text_instance.global_position = owner.floating_text_marker.global_position
		# 如果伤害是浮点数，则格式化为整数
		var format_string = "%0.0f"
		floating_text_instance.start(format_string % hitbox_component.damage, owner)
		
		# 修改信号：传递damage和direction ----------------------------------------
		on_hurt.emit(hitbox_component.force, direction)
		# ---------------------------------------------------------------------
		
		hurt_interval_timer.start()


func _on_hurt_interval_timer_timeout() -> void:
	is_invincible = false
