extends Node

var debug_label: RichTextLabel

func _ready():
	var overlay = get_tree().root.find_child("DebugOverlay", true, false)
	if overlay:
		debug_label = overlay.find_child("RichTextLabel", true, false)

func log(message: String) -> void:
	print(message)
	if debug_label:
		# 将当前文本按行分割（过滤空行）
		var lines = debug_label.text.split("\n", false)
		
		# 插入新消息到最上方
		lines.insert(0, message)
		
		# 限制最大行数（保留最新的20条）
		if lines.size() > 20:
			lines = lines.slice(0, 20)
		
		# 重新组合文本（最新的在最上面）
		debug_label.text = "\n".join(lines)
