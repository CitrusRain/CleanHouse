extends BaseMob
class_name Child


@onready var kid_targets = get_tree().get_nodes_in_group("kid_targets")

func _ready() -> void:
	if $Options:
		var options = $Options.get_children()
		for option in options:
			option.visible = false
		options[randi() % options.size()].visible = true
		for option in options:
			if option.visible == false:
				option.queue_free()

func _process(_delta: float) -> void:
	
	if mob_inventory.get_child_count() != 0:
		pass
	elif mob_inventory.get_child_count() == 0 :
		if target:
			pass
		else:
			find_something_to_do()
		navigation_agent_3d.target_position = target.global_position
	
	mob_interact.check_interactions()
	if attention_span.is_stopped() and mob_inventory.get_child_count() > 0:
		attention_span.wait_time = 1+ randi() % 15
		attention_span.start()

	print("timer time " , attention_span.time_left)
	print("Trash = " , general_functions.item_types.TRASH)

func _on_attention_span_timeout() -> void:
	if mob_inventory.get_child_count() > 0:
		var mine = mob_inventory.get_child(randi() % mob_inventory.get_child_count())
		mine.reparent(get_tree().get_first_node_in_group("Mess"))
		mine.visible = true
		mine.done_with = false
	find_something_to_do()


func find_something_to_do():
	target = kid_targets[randi() % kid_targets.size()]
	print(target.deposit_type, ", is that okay?")
	print(kid_targets)
	if target is not ItemGenerator:
		if target.deposit_type == general_functions.item_types.TRASH \
		or target.deposit_type == general_functions.item_types.WILD \
		or target.deposit_type == general_functions.item_types.DOG_POOP:
			find_something_to_do()
		elif target.deposit_type == general_functions.item_types.DOG_TOY:
			if get_tree().get_first_node_in_group("dog"):
				find_something_to_do() #remove when adding code to find dog
				pass # find dog
			elif randi() % 2 == 1:
				find_something_to_do()
