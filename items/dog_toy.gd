extends pickup

var direction : Vector3 
var velocity : Vector3
var max_throw_frames := 7
var throw_frames := 0

func thrown(velocity: Vector3):
	direction = velocity
	throw_frames = max_throw_frames
	pass

func _physics_process(delta: float) -> void:
	
	if throw_frames > 0:
		if direction:
			velocity.x = direction.x * direction.y
			velocity.z = direction.z * direction.y
		else:
			velocity.x = move_toward(velocity.x, 0, direction.y)
			velocity.z = move_toward(velocity.z, 0, direction.y)
		
		position.x += velocity.x
		position.y += velocity.y
		throw_frames -= 1
	else:
		velocity = Vector3(0,0,0.0) # Make sure to reset velocity
	
	pass
