extends EmptySpace
class_name ItemGenerator 

@export var spawnable_object: PackedScene
#@onready var inventory: Node3D = $Inventory

func _ready() -> void:
	generate()

func _process(_delta: float) -> void:
	if inventory.get_child_count() == 0:
		generate()

func generate():
	var new_item = spawnable_object.instantiate()
	inventory.add_child(new_item)
