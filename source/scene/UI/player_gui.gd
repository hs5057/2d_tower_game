extends CanvasLayer

signal enviar_joystick(j: Joystick)
signal interaction_button_down
@onready var joystick: Area2D = $Joystick
@onready var direction_label: Label = $DirectionLabel
@onready var interaction_button: TextureButton = %InteractionButton
var tween:Tween = create_tween()



func _ready() -> void:
	tween.kill()
	var os_name = OS.get_name()
	if is_mobile(os_name):
		Log.log("当前设备是手机或平板")
		enviar_joystick.emit(joystick)
		interaction_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		interaction_button.toggle_mode = false  # 确保按钮非切换模式
	else:
		Log.log("当前设备是PC或桌面设备")
		self.hide()
	
	interaction_button.pressed.connect(_on_interaction_button_pressed)
	interaction_button.button_down.connect(_on_interaction_button_down)
	interaction_button.button_up.connect(_on_interaction_button_up)
	
	

func _process(delta: float) -> void:
	direction_label.text = "%s" % [joystick.direction]


func is_mobile(os_name: String) -> bool:
	# 判断是否为移动平台（Android/iOS）
	return os_name in ["Android", "iOS"]


func _on_interaction_button_pressed() -> void:
	Log.log("交互按钮按下！")
	pass
	


func _on_interaction_button_down() -> void:
	if tween != null && tween.is_valid():
		tween.kill()
	interaction_button_down.emit()
	tween = create_tween()
	tween.tween_property(interaction_button,"scale",Vector2(1.2,1.2),0.2)


func _on_interaction_button_up() -> void:
	if tween != null && tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.tween_property(interaction_button,"scale",Vector2(1.0,1.0),0.2)
