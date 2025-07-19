extends Node3D

enum game_states { MENUS, IN_LEVEL, PAUSED, LEVEL_END } 
var game_state : game_states

@onready var level_timer: Timer = $LevelTimer
@export var set_level_seconds := 180
@onready var health_bar: TextureProgressBar = get_tree().get_first_node_in_group("HealthBar")
@onready var player_inventory: Node3D = get_tree().get_first_node_in_group("player_inventory")
@onready var mess: Node3D = get_tree().get_first_node_in_group("Mess")
@onready var user_interface: Control = get_tree().get_first_node_in_group("UserInterface")

@onready var rage_bar = get_tree().get_first_node_in_group("RageBar")
var maxx = 0;


func _ready() -> void:
	level_timer.wait_time = set_level_seconds
	level_timer.start()
	#health_bar.max_value = Data.get_level_info()

func _process(_delta: float) -> void:
	level_timer.paused = (game_state == game_states.IN_LEVEL)
	var adjusted_time = general_functions.seconds_to_minutes_and_seconds_string(int(level_timer.time_left))
	get_tree().get_first_node_in_group("TimerDisplay").text = adjusted_time
	live_score()
	health_bar.max_value = maxx
	pass

func live_score():
	#subtract points for objects on the ground
	#dog poop is 3x points (or should we have that separate?)
	var my_points = 0
	for clutter in mess.get_children():
		my_points += clutter.lose_points
	for clutter in player_inventory.get_children():
		my_points += clutter.lose_points
	health_bar.value = my_points
	#print(my_points, "/", health_bar.max_value)
	pass

func add_rage_meter(amount: int) -> bool:
	rage_bar.value += clamp(amount, rage_bar.min_value, rage_bar.max_value)
	return rage_okay()

func reset_rage_meter():
	rage_bar.value = 0

func rage_okay() -> bool:
	return rage_bar.value == rage_bar.max_value

func end_score():
	#get all items not in place and show them on the game over screen
	#subtract points for items not put away or being held by player
	#var clutter_vbox: VBoxContainer = get_tree().get_first_node_in_group("clutter_vbox")
	#var my_points = health_bar.max_value
	var mess_array : Array[Node3D]
	var trashbag_array : Array[Node3D]
	#var trash_array : Array[Node3D]
	
	for clutter in mess.get_children():
		if clutter is TrashBag:
			trashbag_array.append(clutter)
			user_interface.report_unhandled_item(clutter)
		else:
			mess_array.append(clutter)
			
	for clutter in player_inventory.get_children():
		if clutter is TrashBag:
			trashbag_array.append(clutter)
			user_interface.report_unhandled_item(clutter)
		else:
			mess_array.append(clutter)
	
	mess_array.sort_custom(func(a, b): return a.compare_points(b))
	
	for clutter in mess_array:
		#my_points -= clutter.lose_points
		user_interface.report_unhandled_item(clutter)
	#for clutter in player_inventory.get_children():
		#my_points -= clutter.lose_points
		
		
	var trash_texture : Texture2D
	trash_texture = load("res://textures/trashcan.png")
	
	var trash = get_tree().get_nodes_in_group("valuables")
	for o in trash:
		#print(o.get_parent())
		var ogp = general_functions.get_grandparent(o)
		if ogp is TrashCan:
			user_interface.report_mishandled_item(trash_texture,o, ogp.name)
			#my_points -= o.lose_points
		elif o.get_parent() is TrashBag:
			if general_functions.get_great_grandparent(o) is Dumpster:
				user_interface.report_mishandled_item(trash_texture,o, str("Dumpster"))
			else:
				user_interface.report_mishandled_item(trash_texture,o, str("Trash Bag"))
	
	#get_tree().get_current_scene().packup(user_interface.final_score(health_bar.max_value))
	get_tree().get_current_scene().packup(user_interface.final_score())
	
	pass


func _on_level_timer_timeout() -> void:
	get_tree().get_first_node_in_group("game_over_screen").visible = true
	end_score()
	pass # Replace with function body.

func disable_timer_for_other_objective():
	level_timer.paused = true
