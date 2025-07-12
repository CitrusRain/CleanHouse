extends Area3D
class_name pickup

@export var pickup_type: pickup_types
enum  pickup_types { TOY, DIRT } 

@export var done_with := false

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and not done_with:
		reparent(body.get_node("PlayerInventory"))
	pass # Replace with function body.
