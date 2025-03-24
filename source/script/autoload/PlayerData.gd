extends Node

var current_level: int = 0: # 当前等级
	set(value):
		current_level = value
		PlayerSignal.base_house_current_level_changed.emit(current_level)
var damage: int = 1 # 伤害值
var max_health: int = 10: # 最大血量值
	set(value):
		max_health = value
		PlayerSignal.player_max_health_changed.emit(current_health , max_health)
var current_health: int: # 当前血量值
	set(value):
		current_health = value
		PlayerSignal.player_health_changed.emit(current_health , max_health)
		if current_health <= 0:
			PlayerSignal.player_died.emit()
var current_coin: int = 0: # 当前金币数量
	set(value):
		current_coin = value
		PlayerSignal.player_current_coin_changed.emit(current_coin)
var current_wood: int = 0: # 当前木材数量
	set(value):
		current_wood = value
		PlayerSignal.player_current_wood_changed.emit(current_wood)
var current_stone: int = 0: # 当前石头数量
	set(value):
		current_stone = value
		PlayerSignal.player_current_stone_changed.emit(current_stone)
var current_bone: int = 0: # 当前骨头数量
	set(value):
		current_bone = value
		PlayerSignal.player_current_bone_changed.emit(current_bone)
var current_iron_ore: int = 0: # 当前铁矿数量
	set(value):
		current_iron_ore = value
		PlayerSignal.player_current_iron_ore_changed.emit(current_iron_ore)
var current_copper_ore: int = 0: # 当前铜矿数量
	set(value):
		current_copper_ore = value
		PlayerSignal.player_current_copper_ore_changed.emit(current_copper_ore)
var current_gold_ore: int = 0: # 当前金矿数量
	set(value):
		current_gold_ore = value
		PlayerSignal.player_current_gold_ore_changed.emit(current_gold_ore)
		
var current_weapon: String = "Axe": # 当前武器名
	set(value):
		if current_weapon == value:
			return
		print("%s -> %s" % [current_weapon,value])
		current_weapon = value
		PlayerSignal.current_weapon_changed.emit(value)
