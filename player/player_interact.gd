extends ShapeCast3D

@onready var inventory: Node3D = $"../PlayerInventory"

#put thing away?
func check_interactions() -> void:
	for collision in get_collision_count():
		var collider = get_collider(collision) as EmptySpace
		if collider is EmptySpace:
			for item in inventory.get_children():
				var new_place_inventory = collider.get_node("Inventory")
				for held_item in inventory.get_children():
					if held_item.pickup_type == 0 or collider.deposit_type == 0 or (collider.deposit_type == held_item.pickup_type):
						if (held_item.pickup_type != general_functions.item_types.TRASH || (held_item.pickup_type == general_functions.item_types.TRASH && collider.deposit_type == general_functions.item_types.TRASH )):
							deposit(held_item, new_place_inventory)

func deposit(held_item: pickup, new_place_inventory):
	#Additional last minute check to remove bug that lets good_food go into anything
	if held_item is PerishableFood:
		if new_place_inventory.get_parent().deposit_type == general_functions.item_types.GOOD_FOOD \
		or new_place_inventory.get_parent().deposit_type == general_functions.item_types.WILD :
			held_item.done_with = true
			held_item.visible = false
			held_item.reparent(new_place_inventory)
	else:
		held_item.done_with = true
		held_item.visible = false
		held_item.reparent(new_place_inventory)
