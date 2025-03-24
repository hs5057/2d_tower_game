extends Node
# 玩家信号单例

signal base_house_current_level_changed(current_level: int) # 基地当前等级发生改变的信号

# 玩家状态相关信号
signal player_health_changed(current_hp: int , max_hp: int) # 玩家血量发生改变的信号
signal player_max_health_changed(current_hp: int , max_hp: int) # 玩家最大血量发生改变的信号
signal player_died() # 玩家死亡信号

# 资源数量信号
signal player_current_coin_changed(count: int) # 玩家用有的金币数量发生改变
signal player_current_wood_changed(count: int) # 玩家用有的木材数量发生改变
signal player_current_stone_changed(count: int) # 玩家用有的石头数量发生改变
signal player_current_bone_changed(count: int) # 玩家用有的骨头数量发生改变
signal player_current_iron_ore_changed(count: int) # 玩家用有的铁矿数量发生改变
signal player_current_copper_ore_changed(count: int) # 玩家用有的铜矿数量发生改变
signal player_current_gold_ore_changed(count: int) # 玩家用有的金矿数量发生改变


# 快捷栏前被选中的号
signal current_shortcut_bar_index(index_num: int)
signal current_weapon_changed(weapon_name: String)
