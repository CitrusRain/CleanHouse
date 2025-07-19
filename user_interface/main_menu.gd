extends Control

@export var level_button_maker : PackedScene

#TODO: How to dynamically connect a level with it's score?
# Maybe save the level path?
# A scene that gets used inside of Data.tscn that holds a name, a path, and a score?
#

func _ready() -> void:
	
	for lvl in Data.get_children():
		var new_button = level_button_maker.instantiate()
		new_button.file = lvl.level_file
		get_tree().get_first_node_in_group("LevelList").add_child(new_button)
		#print("Data",lvl)
		#print("Data",new_button)
		if lvl.high_score < lvl.passing_score :
			new_button.text = str("Score: " , lvl.high_score , " / " , lvl.max_score , 
			"\nPassing: ", lvl.passing_score)
		else:
			new_button.text = str("Score: " , lvl.high_score , " / " , lvl.max_score )
		
#@export_file("*.tscn") var level_file
#@export var level_Unique_ID : int
#
#@onready var high_score:= 0
#@export var max_score := 2000
#
#@export var passing_score := 500
#@onready var passed := false
		
	#for lvl in get_tree().get_first_node_in_group("LevelList").get_children():
		#
		#print(lvl)

func _on_btn_level_1_pressed() -> void:
	#get_tree().change_scene_to_file(level1)#change level
	pass
	
func travel(player: Player) -> void:
	pass # Replace with function body.
