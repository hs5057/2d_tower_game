extends CanvasLayer

@onready var continue_button: TextureButton = %ContinueButton
@onready var audio_button: TextureButton = %AudioButton
@onready var other_button: TextureButton = %OtherButton
@onready var quit_button: TextureButton = %QuitButton


func _ready() -> void:
	continue_button.pressed.connect(_on_continue_button_pressed)
	audio_button.pressed.connect(_on_audio_button_pressed)
	other_button.pressed.connect(_on_other_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)


func _on_continue_button_pressed() -> void:
	TimeSystem.pause_count -= 1
	hide()
	pass


func _on_audio_button_pressed() -> void:
	pass
	
	
func _on_other_button_pressed() -> void:
	pass


func _on_quit_button_pressed() -> void:
	get_tree().quit()
	pass
