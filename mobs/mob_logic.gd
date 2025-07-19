extends CharacterBody3D
class_name BaseMob

@onready var targets = get_tree().get_nodes_in_group("container")

@onready var looking_for_target := false
@onready var target = targets[randi() % targets.size()]
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var mob_interact: ShapeCast3D = $MobInteract
@onready var mob_inventory: Node3D = $MobInventory
@onready var attention_span: Timer = $AttentionSpan
@onready var navigation_region_3d: NavigationRegion3D = get_tree().get_first_node_in_group("NavigationMap")
@onready var hold_point: Node3D

@export var poop: PackedScene

@export var SPEED := 5

@export var go_sit_down : TimeoutSeat

enum state_machine { PLAY, FIND, FETCH, SIT } 
@onready var activity: state_machine

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	hold_point = $Gremlin/HoldPoint
	for thing in self.get_children():
		if thing is pickup:
			thing.reparent(mob_inventory)

func _process(_delta):
	if activity == state_machine.SIT:
		target = go_sit_down
		looking_for_target = false
		navigation_agent_3d.target_position = target.global_position
		timeout()
	elif  activity == state_machine.FETCH:
		pass
	else:
		if mob_inventory.get_child_count() != 0:
			activity = state_machine.PLAY
			position_item()
		elif mob_inventory.get_child_count() == 0:
			activity = state_machine.FIND
			if target:
				pass
			else:
				target = targets[randi() % targets.size()]
			navigation_agent_3d.target_position = target.global_position
	
		mob_interact.check_interactions()
		if attention_span.is_stopped() and mob_inventory.get_child_count() > 0:
			attention_span.wait_time = 1+ randi() % 15
			attention_span.start()
		
	if mob_inventory.get_child_count() > 0:
		if mob_inventory.get_children()[0] is PerishableFood:
			if not mob_inventory.get_children()[0].expired and randi() % 100 == 1:
				eat(mob_inventory.get_children()[0])

func _physics_process(delta: float) -> void:
	if not looking_for_target:
		var next_position = navigation_agent_3d.get_next_path_position()
		var direction = global_position.direction_to(next_position)
		
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


func _on_attention_span_timeout() -> void:
	if activity == state_machine.PLAY:
		drop_it()
		find_something_to_do()
		if randi() % 10 == 2:
			var poo = poop.instantiate()
			poo.pickup_type = general_functions.item_types.DOG_POOP
			add_child(poo)
			poo.reparent(get_tree().get_first_node_in_group("Mess"))

func find_something_to_do():
	if activity == state_machine.SIT:
		target = go_sit_down
		looking_for_target = false
	else:
		target = targets[randi() % targets.size()]
		if target is not ItemGenerator:
			while target.deposit_type == general_functions.item_types.TRASH:
				target = targets[randi() % targets.size()]
	#elif target is ItemGenerator:
	

func find_somewhere_to_play():
	navigation_agent_3d.target_position = NavigationServer3D.map_get_random_point(get_tree().get_first_node_in_group("NavigationMap").get_navigation_map(), 1, true) 
	$PlayPoint.global_position = navigation_agent_3d.target_position

func position_item():
	for mi in mob_inventory.get_children():
		mi.position = hold_point.position

func sit():
	activity = state_machine.SIT

func timeout():
	if $TimeoutTimer.is_stopped():
		if position.distance_to(go_sit_down.get_seat_position().global_position) < 2 :
			if activity == state_machine.SIT:
				$TimeoutTimer.start()

func _on_timeout_timer_timeout() -> void:
	activity = state_machine.PLAY
	find_something_to_do()

func drop_it() -> void:
	if mob_inventory.get_child_count() > 0:
		var mine = mob_inventory.get_child(randi() % mob_inventory.get_child_count())
		mine.reparent(get_tree().get_first_node_in_group("Mess"))
		mine.visible = true
		mine.done_with = false

func eat(food: pickup) -> void:
	food.queue_free()
