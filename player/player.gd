extends CharacterBody3D
class_name Player 

@onready var player_interact: ShapeCast3D = $PlayerInteract
@onready var player_inventory: Node3D = $PlayerInventory

@onready var game_manager = get_tree().get_first_node_in_group("game_manager")

@export var SPEED = 10.0

var ultimate_ready = false

func _ready() -> void:
	if $Options:
		var options = $Options.get_children()
		for option in options:
			option.visible = false
		options[randi() % options.size()].visible = true
		for option in options:
			if option.visible == false:
				option.queue_free()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if player_interact:
		player_interact.check_interactions()
	
	move_and_slide()
	use_hands()

	#align stuff with hands or drop them
func use_hands():
	var i = 1
	var left_hand = get_tree().get_first_node_in_group("player_left_hand")
	var right_hand = get_tree().get_first_node_in_group("player_right_hand")
	for it in player_inventory.get_children():
		if i == 1:
			it.global_position = left_hand.global_position
			i += 1
		elif i == 2:
			it.global_position = right_hand.global_position
			i += 1
		else:
			it.reparent(get_tree().get_first_node_in_group("Mess"))
			it.visible = true
			it.done_with = false

func get_mad():
	ultimate_ready = game_manager.add_rage_meter(19)

func get_inventory_count() -> int:
	return player_inventory.get_child_count()
