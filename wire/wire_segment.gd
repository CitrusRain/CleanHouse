class_name WireSegment 
extends Node3D

#Previous wire can be of type WireSource
var prev_wire: WireSegment:
	set(another_wire):
		prev_wire = another_wire

#Next wire can be null if held by player
var next_wire: WireSegment:
	set(another_wire):
		next_wire = another_wire


var mesh_instance := MeshInstance3D.new()
var immediate_mesh := ImmediateMesh.new()
var material := ORMMaterial3D.new()

@onready var cyl := CSGCylinder3D.new()

#@onready var join_with := Joint3D.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	first_line(Vector3.ZERO,Vector3.ZERO)
	cyl.height = 100
	cyl.radius = 0.1
	if prev_wire:
		cyl.position = prev_wire.global_position
	get_tree().get_root().add_child(cyl, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not next_wire:
		var p = get_tree().get_first_node_in_group("player")
		global_position = p.global_position
		update_line(prev_wire.global_position, global_position)
		#Joint3D.node_a = get_path()
		#Joint3D.node_b = p.get_path()
		
	if prev_wire:
		update_line(prev_wire.global_position, global_position)
		


#Credit for line() goes to youtube tutorial from Acert Gaming
# https://www.youtube.com/watch?v=JnrhURF1jgM
func first_line(pos_1:Vector3, pos_2:Vector3) -> MeshInstance3D:
	
	mesh_instance.mesh = immediate_mesh
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos_1)
	immediate_mesh.surface_add_vertex(pos_2)
	immediate_mesh.surface_end()
	
#	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.RED
	
	get_tree().get_root().add_child(mesh_instance, true)
	
	return mesh_instance

func update_line(pos_1:Vector3, pos_2:Vector3):
	
	cyl.global_position.x = (pos_1.x + pos_2.x / 2)
	cyl.global_position.z = (pos_1.z + pos_2.z / 2)
	cyl.look_at(pos_2,Vector3.BACK)
	cyl.rotate_y(1.57)
	cyl.height = pos_1.distance_to(pos_2)
	get_tree().get_root().add_child(cyl, true)
