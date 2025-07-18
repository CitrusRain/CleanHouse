extends CharacterBody3D
class_name Player 

@onready var player_interact: ShapeCast3D = $PlayerInteract


@export var SPEED = 10.0


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
