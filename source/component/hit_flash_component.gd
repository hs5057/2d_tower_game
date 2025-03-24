extends Node

'''
注意着色器里必须要勾选resource_local_to_scene 这个来进行唯一化，否则所有敌人会同时闪白
1.双击hit_flash_material.tres
2.展开Resource
3.将Local to Scene 勾选启用
这里只能用 @export var hit_flash_material: ShaderMaterial
不能用 preload()
'''
@export var health_component: Node
@export var sprite: Sprite2D
@export var hit_flash_material: ShaderMaterial

var hit_flash_tween: Tween
signal hit_flash_tween_finished


func _ready() -> void:
	health_component.health_decreased.connect(on_health_decreased)
	sprite.material = hit_flash_material


func on_health_decreased() -> void:
	sprite.material = hit_flash_material
	# is_valid() 返回该tween是否有效
	# 如果已经有一个tween，并且是有效的(在运行), 则让这个tween失效，后面就可以重新分配
	if hit_flash_tween != null && hit_flash_tween.is_valid():
		hit_flash_tween.kill()
		
	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 0.9)
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(sprite.material, "shader_parameter/lerp_percent", 0.0, 0.3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	await hit_flash_tween.finished
	hit_flash_tween_finished.emit()
	hit_flash_tween.kill()
