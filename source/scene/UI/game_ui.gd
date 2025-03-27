extends CanvasLayer

@onready var grid_container: GridContainer = %GridContainer
@onready var weapon_grid: GridContainer = %WeaponGrid
@onready var weapon_1: Button = %Weapon1
@onready var weapon_2: Button = %Weapon2
@onready var slot_background_1: Button = %SlotBackground1
@onready var slot_background_2: Button = %SlotBackground2
@onready var slot_background_3: Button = %SlotBackground3
@onready var slot_background_4: Button = %SlotBackground4
@onready var slot_background_5: Button = %SlotBackground5
@onready var slot_background_6: Button = %SlotBackground6
@onready var slot_background_7: Button = %SlotBackground7
@onready var slot_background_8: Button = %SlotBackground8

@onready var ui_time_display: Control = %UI_TimeDisplay
@onready var settings_interface: CanvasLayer = %SettingsInterface

var weapon_grid_show: bool = false


func _ready() -> void:
	for slot in grid_container.get_children():
		slot.on_focus_entered.connect(_on_slot_on_focus_entered)
		slot.on_pressed.connect(_on_slot_on_pressed)
		
	for slot in weapon_grid.get_children():
		slot.on_focus_entered.connect(_on_slot_on_focus_entered)
		slot.on_pressed.connect(_on_slot_on_pressed)
	
	# 设置按钮信号
	ui_time_display.settings_button_pressed.connect(_on_ui_time_display_settings_button_pressed)


func _on_slot_on_focus_entered(_index_num: int) -> void:
	pass


func _on_slot_on_pressed(_index_num: int, _type_name: String) -> void:
	# 如果点击的是一级快捷栏，则根据情况显示或隐藏二级快捷栏
	if _type_name == "Weapon":
		if !weapon_grid_show:
			weapon_grid.show()
			weapon_grid_show = true
		else:
			weapon_grid.hide()
			weapon_grid_show = false
	
	# 如果点击的是斧头
	if _type_name == "Weapon_1":
		var slot = weapon_1.get_child(1).duplicate()
		slot_background_1.get_child(1).queue_free()
		slot_background_1.add_child(slot)
		PlayerData.current_weapon = "Axe"
		weapon_1.scale_tween()
		weapon_2.scale_tween()
		await weapon_1.on_scale_tween_finished
		weapon_grid.hide()
		weapon_grid_show = false
		
	# 如果点击的是镐子
	elif _type_name == "Weapon_2":
		var slot = weapon_2.get_child(1).duplicate()
		slot_background_1.get_child(1).queue_free()
		slot_background_1.add_child(slot)
		PlayerData.current_weapon = "Pickaxe"
		weapon_1.scale_tween()
		weapon_2.scale_tween()
		await weapon_2.on_scale_tween_finished
		weapon_grid.hide()
		weapon_grid_show = false


func _on_ui_time_display_settings_button_pressed() -> void:
	TimeSystem.pause_count += 1
	settings_interface.show()
