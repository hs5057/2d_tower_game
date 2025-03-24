extends StaticBody2D
class_name BaseHarvestableObjet

@export var hurtbox: Area2D
@export var resources_scene: PackedScene
@onready var sprite: Sprite2D = $Sprite2D
@onready var floating_text_marker: Marker2D = %FloatingTextMarker
@onready var health_component: HealthComponent = %HealthComponent
@onready var hit_flash_component: Node = %HitFlashComponent
@onready var hurt_box_component: HurtBoxComponent = %HurtBoxComponent
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var player:Node2D


func _ready() -> void:
	hurtbox.on_hurt.connect(_on_hurt)
	health_component.died.connect(_on_died)
	hit_flash_component.hit_flash_tween_finished.connect(_on_hit_flash_tween_finished)
	player = get_tree().get_first_node_in_group("Player")


func hurt_tween() -> void:
	var _hurt_tween: Tween = create_tween()
	_hurt_tween.tween_property(sprite,"rotation_degrees", -10, 0.2)
	_hurt_tween.tween_property(sprite,"rotation_degrees", 10, 0.2)
	_hurt_tween.tween_property(sprite,"rotation_degrees", 0, 0.15)


func drop_resources() -> void:
	var resources_instance = resources_scene.instantiate()
	var foreground_layer = get_tree().get_first_node_in_group("ForegroundLayer")
	# 使用 call_deferred 延迟添加子节点
	foreground_layer.add_child(resources_instance)
	resources_instance.harvestable_resources.scale = resources_instance.harvestable_resources.scale_vector2
	resources_instance.drop(position)
	await get_tree().create_timer(0.15).timeout
	resources_instance.call_deferred("drop_audio_play")


func death_tween() -> void:
	# 重置材质
	if hit_flash_component.sprite.material == hit_flash_component.hit_flash_material:
		hit_flash_component.sprite.material = null

	# 透明度渐变动画
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, 1.0)
	await tween.finished
	
	# 掉落资源和删除节点
	#call_deferred("drop_resources")
	call_deferred("queue_free")


func _on_hurt(_damage: float, _direction: Vector2) -> void:
	hurt_tween()


func _on_died() -> void:
	hurt_box_component.monitoring = false
	hurt_box_component.monitorable = false
	collision_shape_2d.disabled = true
	drop_resources()
	pass
	#death_tween()


func _on_hit_flash_tween_finished() -> void:
	if health_component.current_health <= 0:
		death_tween()
