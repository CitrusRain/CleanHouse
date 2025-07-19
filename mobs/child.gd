extends BaseMob
class_name Child


@onready var kid_targets = get_tree().get_nodes_in_group("kid_targets")
var previous_target
var previous_play_point_pos: Vector3
var new_play_point: Vector3

#Variables for playing fetch
var fetch_mode: bool
var throw_vector: Vector3
var dog_choice: Dog

func _ready() -> void:
	if $Options:
		var options = $Options.get_children()
		for option in options:
			option.visible = false
		options[randi() % options.size()].visible = true
		for option in options:
			if option.visible == false:
				option.queue_free()
			else:
				hold_point = option.get_child(0)
	previous_play_point_pos = position
	find_something_to_do()
	

func _process(_delta: float) -> void:
	if activity == state_machine.SIT:
		target = go_sit_down
		looking_for_target = false
		navigation_agent_3d.target_position = target.global_position
		timeout()
	#elif  activity == state_machine.FETCH:
		#TODO: Rework FETCH logic to state machine
		#pass
	else:	
		if mob_inventory.get_child_count() != 0:
			activity = state_machine.PLAY
			position_item()
			if mob_inventory.get_children()[0].pickup_type == general_functions.item_types.DOG_TOY:
				var dogs = get_tree().get_nodes_in_group("dog")
				if dogs.size() > 0:
					dog_choice = get_tree().get_nodes_in_group("dog")[randi() % get_tree().get_nodes_in_group("dog").size()]
					fetch_mode = true
			
					
			pass
		elif mob_inventory.get_child_count() == 0 :
			activity = state_machine.FIND
			fetch_mode = false
			if target:
				pass
			else:
				find_something_to_do()
			navigation_agent_3d.target_position = target.global_position
	
		mob_interact.check_interactions()
	
	if mob_inventory.get_child_count() > 0:
		if mob_inventory.get_children()[0] is PerishableFood:
			if not mob_inventory.get_children()[0].expired and randi() % 100 == 1:
				eat(mob_inventory.get_children()[0])
		
#	print("Trash = " , general_functions.item_types.TRASH)

func _physics_process(delta: float) -> void:
	var direction 
	if fetch_mode:
		navigation_agent_3d.target_position = dog_choice.position
		var next_position = navigation_agent_3d.get_next_path_position()
		direction = global_position.direction_to(next_position)
		if next_position.distance_to(navigation_agent_3d.get_final_position()) < .005:
			if mob_inventory.get_child_count() != 0:
				throw_vector = Vector3(randf() * 3.0 - 2, randf() * 3, randf() * 3.0 - 2)
				mob_inventory.get_child(0).thrown(throw_vector)
				mob_inventory.get_child(0).done_with = false
				mob_inventory.get_child(0).reparent(get_tree().get_first_node_in_group("Mess"))
				fetch_mode = false
	else:
		if not looking_for_target:
			var next_position = navigation_agent_3d.get_next_path_position()
			
			if next_position.distance_to(navigation_agent_3d.get_final_position()) < 2 and attention_span.is_stopped():
			#if next_position == navigation_agent_3d.get_final_position():
				attention_span.wait_time = 1+ randi() % 15
				attention_span.start()
			elif next_position.distance_to(navigation_agent_3d.get_final_position()) < 2:
				pass
			else:
				attention_span.stop()
			direction = global_position.direction_to(next_position)
			
			#var new_play_point = navigation_agent_3d.get_final_position()
			
			var i = 0
			while previous_play_point_pos.distance_to($PlayPoint.position) < 5.0 \
				and i < 400:
			#check distance and don't let the new one match the old one
				find_somewhere_to_play()
				#print("new point is " , new_play_point , "; distance to new point is ", previous_play_point_pos.distance_to(new_play_point))
				i += 1
			
			
			if previous_play_point_pos != new_play_point:
				previous_play_point_pos = $PlayPoint.position
				$PlayPoint.position = new_play_point
		#----END OF NORMAL MODE----#
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()

func find_somewhere_to_play():
	navigation_agent_3d.target_position = NavigationServer3D.map_get_random_point(get_tree().get_first_node_in_group("NavigationMap").get_navigation_map(), 1, true) 
	#print(navigation_agent_3d.target_position)
	$PlayPoint.position = navigation_agent_3d.target_position

func _on_attention_span_timeout() -> void:
	if activity == state_machine.PLAY:
		if mob_inventory.get_child_count() > 0:
			var mine = mob_inventory.get_child(randi() % mob_inventory.get_child_count())
			mine.reparent(get_tree().get_first_node_in_group("Mess"))
			mine.visible = true
			mine.done_with = false
		find_something_to_do()


func find_something_to_do():
	target = kid_targets[randi() % kid_targets.size()]
	if target is not ItemGenerator:
		if target.deposit_type == general_functions.item_types.TRASH \
		or target.deposit_type == general_functions.item_types.WILD \
		or target.deposit_type == general_functions.item_types.DOG_POOP:
			find_something_to_do()
		elif target.deposit_type == general_functions.item_types.DOG_TOY:
			var dogs = get_tree().get_nodes_in_group("dog")
			if dogs.size() > 0:
				dog_choice = get_tree().get_nodes_in_group("dog")[randi() % get_tree().get_nodes_in_group("dog").size()]
				pass # this is here so kid will pick up dog toy if dog exists. Then fetch mode starts with toy held
			elif randi() % 50 == 1:
				pass 
			else:
				find_something_to_do()
			

func _on_timeout_timer_timeout() -> void:
	activity = state_machine.PLAY
	find_something_to_do()
