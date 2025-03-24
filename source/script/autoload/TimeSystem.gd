extends Node

# 时间流速配置（测试用）
const REAL_SECONDS_PER_GAME_HOUR = 30  # 现实30秒 = 游戏1小时
var game_time_speed: float = 1.0 / REAL_SECONDS_PER_GAME_HOUR

var wave_interval_hours = 6  # 每6小时生成一波
var total_game_minutes: float = 0.0

# 时间初始值
var year: int = 1
var month: int = 1
var day: int = 1
var hour: int = 8
var minute: int = 0
var total_minutes: float = 0.0

var is_daytime: bool = false
var current_season: String = "Spring"

signal time_updated(year: int, month: int, day: int, hour: int, minute: int)
signal day_night_switch(is_daytime: bool)
signal season_changed(season: String)

func _process(delta: float):
	advance_time(delta * game_time_speed * 3600)

func advance_time(seconds: float):
	total_minutes += seconds / 60.0
	var delta_minutes = int(total_minutes)
	total_minutes -= delta_minutes
	
	minute += delta_minutes
	var delta_hour_total = minute / 60
	minute = minute % 60
	hour += delta_hour_total
	
	var delta_day = hour / 24
	hour = hour % 24
	
	if delta_day > 0:
		day += delta_day
		while day > 30:
			day -= 30
			month += 1
			if month > 12:
				month = 1
				year += 1
		update_season()
	
	var new_daytime = (hour >= 6 and hour < 18)
	if new_daytime != is_daytime:
		is_daytime = new_daytime
		day_night_switch.emit(is_daytime)
	
	time_updated.emit(year, month, day, hour, minute)
	#print("[TimeSystem] 当前日期: %04d-%02d-%02d" % [year, month, day])
	
	# 触发生成波次（每小时检查一次）
	if hour % wave_interval_hours == 0 && minute == 0:
		EnemyManager.spawn_enemies()
		
	total_game_minutes += seconds / 60.0

func update_season():
	if month in [1, 2, 3]:
		current_season = "Spring"
	elif month in [4, 5, 6]:
		current_season = "Summer"
	elif month in [7, 8, 9]:
		current_season = "Autumn"
	else:
		current_season = "Winter"
	season_changed.emit(current_season)


func get_total_game_minutes() -> float:
	return total_game_minutes
