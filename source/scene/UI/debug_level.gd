extends Control

@onready var level_up_button: Button = %LevelUpButton
@onready var level_down_button: Button = %LevelDownButton
@onready var current_level_label: Label = %CurrentLevelLabel



func _ready():
	level_up_button.pressed.connect(_on_level_up_pressed)
	level_down_button.pressed.connect(_on_level_down_pressed)
	current_level_label.text = "当前等级: " + str(PlayerData.current_level)


func _on_level_up_pressed():
	PlayerData.current_level += 1
	current_level_label.text = "当前等级: " + str(PlayerData.current_level)


func _on_level_down_pressed():
	PlayerData.current_level = max(0, PlayerData.current_level - 1)
	current_level_label.text = "当前等级: " + str(PlayerData.current_level)
