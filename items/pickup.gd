extends Area3D
class_name pickup

@export var pickup_type: general_functions.item_types

@export var done_with := false

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

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and not done_with:
		reparent(body.get_node("PlayerInventory"))
