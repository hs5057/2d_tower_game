extends Node2D

@onready var world: Node2D = %World
@onready var player: Player = %Player
@onready var entity: Node2D = %Entity
@onready var game_ui: CanvasLayer = %GameUI
@onready var enemy_node_layer: Node2D = %EnemyNodeLayer


func _ready() -> void:
	$ForestAudio.fade_in(4.0, -15)
	# 初始生成
	await get_tree().create_timer(1.0).timeout  # 等待场景加载
	EnemyManager.spawn_enemies()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		var g_position = get_global_mouse_position()
		print(g_position)
