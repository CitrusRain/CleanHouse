extends ShapeCast3D

@onready var inventory: Node3D = $"../PlayerInventory"


func check_interactions() -> void:
	for collision in get_collision_count():
		var collider = get_collider(collision)
		if collider is EmptySpace:
			for item in inventory.get_children():
				print(collider)
				var new_place = collider.get_node("Inventory")
				for held_item in inventory.get_children():
					held_item.done_with = true
					held_item.visible = false
					held_item.reparent(new_place)
