extends Area2D
class_name Joystick

@onready var rango: Sprite2D = $Rango
@onready var palanca: Sprite2D = $Palanca
@onready var radius = $CollisionShape2D.shape.radius
var distance: float
var direction: Vector2
var index: int = -1
var tween:Tween = create_tween()
var tween2:Tween = create_tween()

func _ready() -> void:
	tween.kill()
	tween2.kill()


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.is_pressed() and index == -1:
			distance = global_position.distance_to(event.position)
			if distance < radius:
				
				# 停止旧 Tween 点击摇杆后，渐变效果，让摇杆0.2秒内透明度为1
				if tween != null && tween.is_valid():
					tween.kill()
				tween = create_tween()
				tween.tween_property(rango, "modulate:a",1.0, 0.2)
				
				if tween2 != null && tween2.is_valid():
					tween2.kill()
				tween2 = create_tween()
				tween2.tween_property(palanca, "modulate:a",1.0, 0.2)
				
				index = event.index
				palanca.global_position = event.position
				direction = global_position.direction_to(palanca.global_position) * distance / radius
			else:
				return
		elif event.index == index:
			index = -1
			palanca.position = Vector2.ZERO
			direction = Vector2.ZERO
			
			# 停止旧 Tween 松开摇杆后，渐变效果，让摇杆1.5秒内透明度为0.2
			if tween != null && tween.is_valid():
				tween.kill()
			tween = create_tween()
			tween.tween_property(rango, "modulate:a",0.2, 1.5)
			
			if tween2 != null && tween2.is_valid():
				tween2.kill()
			tween2 = create_tween()
			tween2.tween_property(palanca, "modulate:a",0.2, 1.5)

	
	
	if event is InputEventScreenDrag:
		if event.index == index:
			distance = global_position.distance_to(event.position)
			if distance <= radius:
				palanca.global_position = event.position
				direction = global_position.direction_to(palanca.global_position) * distance / radius
			else:
				direction = global_position.direction_to(event.position)
				palanca.global_position = (direction * radius) + global_position
