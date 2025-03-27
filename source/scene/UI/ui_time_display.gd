# UI_TimeDisplay.gd
extends Control

@onready var time_label: Label = %TimeLabel
@onready var year_label: Label = %YearLabel
@onready var date_label: Label = %DateLabel
@onready var day_night_texture: TextureRect = %DayNightTexture
@onready var season_texture: TextureRect = %SeasonTexture
@onready var pause_button: TextureButton = %PauseButton
@onready var settings_button: TextureButton = %SettingsButton


const MOON = preload("res://assets/texture/ui/moon.png")
const SUN = preload("res://assets/texture/ui/sun.png")
signal settings_button_pressed
var pause_button_pressed_state:bool = false


func _ready():
	if TimeSystem:
		TimeSystem.day_night_switch.connect(_on_day_night_switch)
		TimeSystem.time_updated.connect(_on_time_updated)
		TimeSystem.season_changed.connect(_on_season_changed)
		# 调试输出信号连接状态
		#print("TimeSystem信号连接状态：", 
		#TimeSystem.time_updated.is_connected(_on_time_updated))
	else:
		push_error("TimeSystem 未加载！")
	
	pause_button.pressed.connect(_on_pause_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	
	pause_button.texture_normal.region = Rect2(224, 112, 16, 16)


func _on_time_updated(year: int, month: int, day: int, hour: int, minute: int):
	year_label.text = str(year) + "年"
	date_label.text = "%02d/%02d" % [month, day]
	time_label.text = "%02d:%02d" % [hour, minute]


func _on_season_changed(season: String):
	#print("season：",season)
	var icon_path = "res://assets/texture/ui/seasons/%s.png" % season.to_lower()
	season_texture.texture = load(icon_path)


func _on_day_night_switch(is_daytime: bool):
	day_night_texture.texture = SUN if is_daytime else MOON


func _on_pause_button_pressed() -> void:
	set_pause_button_textures(pause_button_pressed_state)
	if pause_button_pressed_state:
		TimeSystem.pause_count -= 1
	else:
		TimeSystem.pause_count += 1
	
	pause_button_pressed_state = !pause_button_pressed_state


func set_pause_button_textures(state) -> void:
	if state == true:
		pause_button.texture_normal.region = Rect2(224, 112, 16, 16)
	else:
		pause_button.texture_normal.region = Rect2(240, 112, 16, 16)



func _on_settings_button_pressed() -> void:
	settings_button_pressed.emit()
	pass
