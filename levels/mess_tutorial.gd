extends Node3D

var has_sat := false

func _ready() -> void:
	for i in find_children("*", "Label3D"):
		i.visible = true

func _process(delta: float) -> void:
	$"../GameManager".disable_timer_for_other_objective()
	if get_child_count() == 0 and $"../Player".player_inventory.get_child_count() == 0 and \
	$"../Child".mob_inventory.get_child_count() == 0 and has_sat:
		print(true)
		get_tree().get_first_node_in_group("game_over_screen").visible = true
		$"../GameManager".end_score()
