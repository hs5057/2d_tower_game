extends Node2D

@onready var fog_mask: CanvasModulate = $FogMask
@onready var spawn_point_top: Marker2D = %SpawnPointTop
@onready var spawn_point_right: Marker2D = %SpawnPointRight
@onready var spawn_point_down: Marker2D = %SpawnPointDown
@onready var spawn_point_left: Marker2D = %SpawnPointLeft


func _ready():
	TimeSystem.day_night_switch.connect(_on_day_night_switch)


func _on_day_night_switch(is_daytime: bool):
	var target_color = Color(1,1,1,1) if is_daytime else Color(0,0,0,1)
	var target_alpha = 0.0 if is_daytime else 1.0
	
	# 雾效过渡
	var tween = create_tween()
	tween.tween_property(fog_mask, "color", target_color, 2.0)
	
	# 灯光控制
	var lights = get_tree().get_nodes_in_group("PointLight")
	for light in lights:
		var light_tween = create_tween()
		light_tween.tween_property(light, "color:a", target_alpha, 2.0)
