extends ShapeCast3D

@onready var mob_inventory: Node3D = $"../MobInventory"

#take thing out
func check_interactions() -> void:
	for collision in get_collision_count():
		var collider = get_collider(collision) as EmptySpace
		if collider is EmptySpace and mob_inventory.get_child_count() == 0:
			var i = collider.inventory.get_child_count()
			if i > 0:
				var mine = collider.inventory.get_child(randi() % i)
				mine.reparent(mob_inventory)
				mine.visible = true
				
						
						
func deposit(held_item, new_place):
	held_item.done_with = true
	held_item.visible = false
	held_item.reparent(new_place)
