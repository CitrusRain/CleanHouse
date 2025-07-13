class_name EmptySpace 
extends StaticBody3D

@export var size := -1
@export var deposit_type: general_functions.item_types
@export var trash_bag: PackedScene
@onready var inventory: Node3D = $Inventory

func _ready() -> void:
	if $Label3D.text == "#":
		$Label3D.text = str(deposit_type)

func _physics_process(delta: float) -> void:
	if size > 0 and inventory.get_child_count() > size and trash_bag:
		var tb = trash_bag.instantiate()
		tb.pickup_type = 1
		add_child(tb)
		for i in inventory.get_children():
			i.reparent(tb)
