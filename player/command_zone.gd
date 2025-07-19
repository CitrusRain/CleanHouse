extends Area3D
class_name CommandZone 

@export var max_radius := 3
@export var rate_of_change := 0.05
@export var lifetime := 0.75
@export var height_helper = 5
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var csg_cylinder_3d: CSGCylinder3D = $CSGCylinder3D
@onready var timer: Timer = $Timer

var current_radius := 0.0

func _ready() -> void:
	collision_shape_3d.shape.radius = current_radius
	csg_cylinder_3d.radius = current_radius
	timer.wait_time = lifetime

func _physics_process(_delta: float) -> void:
	if current_radius < max_radius:
		current_radius += rate_of_change
		collision_shape_3d.shape.radius = current_radius
		csg_cylinder_3d.radius = current_radius
		pass
	elif timer.is_stopped():
		timer.start()
	else:
		csg_cylinder_3d.height += rate_of_change / height_helper
		csg_cylinder_3d.position.y += rate_of_change / (height_helper * 2)


func _on_timer_timeout() -> void:
	self.queue_free()


func _on_body_entered(body: Node3D) -> void:
	#print("body entered by " , body)
	if body is BaseMob:
		body.sit()
		
	pass # Replace with function body.
