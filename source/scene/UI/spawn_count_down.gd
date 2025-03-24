extends Control
class_name SpawnCountdown  # 添加类名声明

@onready var timer: Timer = $CountdownTimer
@onready var progress_bar: TextureProgressBar = $TextureProgressBar

enum SpawnDirection { TOP, RIGHT, BOTTOM, LEFT }
var direction: SpawnDirection = SpawnDirection.TOP  # 默认顶部


signal countdown_finished


func start_countdown(duration: float, direction: SpawnDirection):
	self.direction = direction
	visible = true
	progress_bar.max_value = duration
	progress_bar.value = 0
	timer.start(duration)
	timer.timeout.connect(_on_timer_timeout)
	await countdown_finished


func _on_timer_timeout():
	visible = false  # 倒计时结束隐藏
	countdown_finished.emit()


func _process(delta: float):
	if timer.is_stopped():
		return
	progress_bar.value = progress_bar.max_value - timer.time_left
