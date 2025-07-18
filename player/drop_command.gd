extends CommandZone



func _on_body_entered(body: Node3D) -> void:
	print("body entered by " , body)
	if body is BaseMob:
		body.drop_it()
		
	pass # Replace with function body.
