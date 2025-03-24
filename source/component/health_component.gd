extends Node
class_name HealthComponent

@export var max_health: float = 10 # 默认最大健康值
@onready var current_health: float # 当前健康值

signal died # 死亡信号
signal health_changed(current_health: float, max_health: float) # 血量改变信号
signal health_decreased # 血量减少信号
signal health_recovered(heal_amount: float) # 血量恢复


func _ready() -> void:
	current_health = max_health


func damage(damage_amount: float):
	current_health = clamp(current_health - damage_amount, 0, max_health)
	health_changed.emit(current_health,max_health)
	if damage_amount > 0:
		health_decreased.emit()
	elif damage_amount < 0:
		if current_health < max_health:
			health_recovered.emit(damage_amount)
	# 使用延迟模式调用该 Callable 所代表的方法，即在当前帧的末尾调用。
	Callable(check_death).call_deferred()


# 治疗
func heal(heal_amount: float):
	damage(-heal_amount)


# 获取血量百分比
func get_health_percent():
	if max_health <= 0:
		return 0
	return min(current_health / max_health, 1)


# 检测死亡
func check_death():
	if current_health == 0:
		died.emit()
		## 如果owner是敌人组，且正在播放，则等音频播放完毕后再销毁敌人自身
		#if owner.is_in_group("Enemy") and owner.damage_audio.playing:
			#await owner.damage_audio.finished
