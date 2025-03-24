extends Node2D

@onready var label: Label = %Label

# 敌人基础颜色
var enemy_base_color: Color = Color(0.747, 0.0, 0.0, 1)
# 玩家基础颜色
var player_base_color: Color = Color(0.71, 0.071, 0.082, 1)
# 恢复生命的颜色
var player_health_recovery_color: Color = Color(0.129, 0.82, 0.408, 1)
# 恢复魔法的颜色
var player_magic_recovery_color: Color = Color(0.114, 0.224, 1, 1)


func _ready() -> void:
	pass


func start(text: String, _owner: Node2D, hp_recover: bool = false, mp_recover: bool = false) -> void:
	if _owner.is_in_group("Enemy") or _owner is BaseHarvestableObjet:
		label.set("theme_override_colors/font_shadow_color" , enemy_base_color)
	elif _owner.is_in_group("Player"):
		if hp_recover:
			label.set("theme_override_colors/font_shadow_color" , player_health_recovery_color)
		elif mp_recover:
			label.set("theme_override_colors/font_shadow_color" , player_magic_recovery_color)
		else:
			label.set("theme_override_colors/font_shadow_color" , player_base_color)
	
	label.text = "-" + text
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "global_position", (global_position + Vector2(0, -8)), 0.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	# 等待上面的tween同步执行完以后，再开始执行下面的tween
	tween.chain()
	
	tween.tween_property(self, "global_position", (global_position + Vector2(0, -24)), 0.5)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.5)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	tween.chain()
	
	tween.tween_callback(queue_free)
	
	var scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", Vector2.ONE * 1.5, 0.15)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	scale_tween.tween_property(self, "scale", Vector2.ONE, 0.15)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
