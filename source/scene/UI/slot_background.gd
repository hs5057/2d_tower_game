extends Button

@export var index_num: int = 0
@export var type_name: String = ""
@export var slot_name: String = ""

signal on_focus_entered(_index_num)
signal on_focus_exited
signal on_pressed(_index_num , _type_name)
signal on_scale_tween_finished

func _ready() -> void:
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	pressed.connect(_on_pressed)


func _on_focus_entered() -> void:
	on_focus_entered.emit(index_num)
	PlayerSignal.current_shortcut_bar_index.emit(index_num)


func _on_focus_exited() -> void:
	on_focus_exited.emit()


func _on_pressed() -> void:
	on_pressed.emit(index_num , type_name)


func scale_tween() -> void:
	var _scale_tween = create_tween()
	_scale_tween.tween_property(self, "scale", Vector2.ZERO, 0.3)
	await _scale_tween.finished
	on_scale_tween_finished.emit()
	
