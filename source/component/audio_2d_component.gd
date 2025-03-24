extends AudioStreamPlayer2D
class_name Audio2DComponent

@export var audios : Array[AudioStream] = []

# 参数说明 
# index -> audios数组总的索引
# VDB -> volume_db 音量大小
# set_pitch_scale 是否音高缩放
func play_audio(index: int, VDB: int = 0, set_pitch_scale: bool = false) -> void:
		pitch_scale = 1 if !set_pitch_scale else randf_range(0.8,1.2)
		volume_db = VDB

		stream = audios[index]
		play()


# 渐入效果
func fade_in(duration: float = 2.0, db: int = 0) -> void:
		stream = audios[0]
		volume_db = -80  # 初始音量设为最小
		play()
		var fade_in_tween = create_tween()
		fade_in_tween.tween_property(self, "volume_db", db, duration)
		await fade_in_tween.finished


# 渐出效果
func fade_out(duration: float = 2.0) -> void:
		volume_db = -80  # 初始音量设为最小
		var fade_out_tween = create_tween()
		fade_out_tween.tween_property(self, "volume_db", volume_db, duration)
		await fade_out_tween.finished
		stop()
