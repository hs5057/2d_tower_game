extends Control

@onready var resources_button: TextureButton = %ResourcesButton
@onready var nav_box: Panel = %NavBox
@onready var margin_container: MarginContainer = %MarginContainer

@onready var coin_count_label: Label = %CoinCountLabel
@onready var wood_count_label: Label = %WoodCountLabel
@onready var stone_count_label: Label = %StoneCountLabel
@onready var bone_count_label: Label = %BoneCountLabel
@onready var iron_ore_count_label: Label = %IronOreCountLabel
@onready var copper_ore_count_label: Label = %CopperOreCountLabel
@onready var gold_ore_count_label: Label = %GoldOreCountLabel

var is_expand: bool = false


func _ready() -> void:
	
	nav_box.hide()
	margin_container.hide()
	init_resources_count()
	
	resources_button.pressed.connect(_on_resources_button_pressed)
	PlayerSignal.player_current_coin_changed.connect(_on_player_current_coin_changed)
	PlayerSignal.player_current_wood_changed.connect(_on_player_current_wood_changed)
	PlayerSignal.player_current_stone_changed.connect(_on_player_current_stone_changed)
	PlayerSignal.player_current_bone_changed.connect(_on_player_current_bone_changed)
	PlayerSignal.player_current_iron_ore_changed.connect(_on_player_current_iron_ore_changed)
	PlayerSignal.player_current_copper_ore_changed.connect(_on_player_current_copper_ore_changed)
	PlayerSignal.player_current_gold_ore_changed.connect(_on_player_current_gold_ore_changed)



func init_resources_count() -> void:
	coin_count_label.text = str(PlayerData.current_coin)
	wood_count_label.text = str(PlayerData.current_wood)
	stone_count_label.text = str(PlayerData.current_stone)
	bone_count_label.text = str(PlayerData.current_bone)
	iron_ore_count_label.text = str(PlayerData.current_iron_ore)
	copper_ore_count_label.text = str(PlayerData.current_copper_ore)
	gold_ore_count_label.text = str(PlayerData.current_gold_ore)


func switch_nav_box() -> void:
	if is_expand == false:
		var size_tween:Tween = create_tween()
		size_tween.tween_property(nav_box, "size:x",380,0.3).from(0)
		nav_box.show()
		await size_tween.finished
		is_expand = true
		size_tween.kill()
		
		var modulate_tween:Tween = create_tween()
		margin_container.set_modulate(Color(1,1,1,0))
		margin_container.show()
		modulate_tween.tween_property(margin_container, "modulate",Color(1,1,1,1), 0.3)
		await modulate_tween.finished
		modulate_tween.kill()
	else:
		var modulate_tween:Tween = create_tween()
		margin_container.set_modulate(Color(1,1,1,1))
		modulate_tween.tween_property(margin_container, "modulate",Color(1,1,1,0), 0.3)
		await modulate_tween.finished
		margin_container.hide()
		modulate_tween.kill()

		var size_tween:Tween = create_tween()
		size_tween.tween_property(nav_box, "size:x",0,0.3).from(380)
		await size_tween.finished
		nav_box.hide()
		is_expand = false
		size_tween.kill()


func _on_resources_button_pressed() -> void:
	switch_nav_box()


func _on_player_current_coin_changed() -> void:
	init_resources_count()


func _on_player_current_wood_changed(count: int) -> void:
	print("count:",count)
	wood_count_label.text = str(count)


func _on_player_current_stone_changed(count: int) -> void:
	stone_count_label.text = str(count)


func _on_player_current_bone_changed(count: int) -> void:
	bone_count_label.text = str(count)


func _on_player_current_iron_ore_changed(count: int) -> void:
	iron_ore_count_label.text = str(count)


func _on_player_current_copper_ore_changed(count: int) -> void:
	copper_ore_count_label.text = str(count)


func _on_player_current_gold_ore_changed(count: int) -> void:
	gold_ore_count_label.text = str(count)
