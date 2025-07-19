extends Button

var file: String

func _on_pressed() -> void:
	get_tree().change_scene_to_file(file)#change level
	pass # Replace with function body.
