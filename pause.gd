extends Control


var paused := false


func toggle_pause():
	if paused:
		self.hide()
	else:
		self.show()
	
	paused = !paused
	get_tree().paused = paused


func _on_resume_pressed() -> void:
	toggle_pause()


func _on_quit_pressed() -> void:
	self.queue_free()
