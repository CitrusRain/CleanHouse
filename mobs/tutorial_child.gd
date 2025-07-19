extends Child


func find_something_to_do():
	target = $"../NavigationRegion3D/Environment/Refridgerator3"
	if target is not ItemGenerator:
		if target.deposit_type == general_functions.item_types.TRASH \
		or target.deposit_type == general_functions.item_types.WILD \
		or target.deposit_type == general_functions.item_types.DOG_POOP:
			find_something_to_do()

func eat(food: pickup) -> void:
	drop_it()
	
func sit():
	activity = state_machine.SIT
	$"../Mess".has_sat = true
