extends Area3D
class_name pickup

@export var pickup_type: general_functions.item_types

@export var done_with := false
@export var lose_points := 100
@export var trashed_penalty := 0

var move_to_inventory = false
var player_body

func _ready() -> void:
	if $Label3D.text == "#":
		$Label3D.text = str(pickup_type)
	#$Label3D.visible = false
	if $Options:
		var options = $Options.get_children()
		for option in options:
			option.visible = false
		options[randi() % options.size()].visible = true
		for option in options:
			if option.visible == false:
				option.queue_free()

func _process(_delta: float) -> void:
	if move_to_inventory:
		var inven = player_body.get_node("PlayerInventory")
		if inven.get_child_count() <= 2:
			reparent(inven)
		move_to_inventory = false
		

func _on_body_entered(body: Node3D) -> void:
	if body is Player and not done_with:
		if body.get_inventory_count() < 2:
			move_to_inventory = true
			player_body = body
			body.get_mad()

func compare_points(compareto: pickup) -> bool:
	if (lose_points == compareto.lose_points):
		return pickup_type < compareto.pickup_type
	var point_vals = (lose_points < compareto.lose_points)
	return point_vals
