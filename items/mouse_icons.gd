extends PerishableFood

func _on_expire_timer_timeout() -> void:
	queue_free()
	
