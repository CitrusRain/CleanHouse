extends Control

@export var level_button_maker : PackedScene

#TODO: How to dynamically connect a level with it's score?
# Maybe save the level path?
# A scene that gets used inside of Data.tscn that holds a name, a path, and a score?
#

func _ready() -> void:
	get_tree().root.min_size.y = 550
	
	get_tree().root.min_size.x = 960
	get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	#var min_size = Window.min_size
	#min_size.y = 550
	#DisplayServer.window_set_min_size(min_size)
	for lvl in Data.get_children():
		var new_button = level_button_maker.instantiate()
		new_button.file = lvl.level_file
		get_tree().get_first_node_in_group("LevelList").add_child(new_button)
		#print("Data",lvl)
		#print("Data",new_button)
		if lvl.high_score < lvl.passing_score :
			new_button.text = str(lvl.title , "\nScore: " , lvl.high_score , " / " , lvl.max_score , 
			"\nPassing: ", lvl.passing_score)
		else:
			new_button.text = str(lvl.title , "\nScore: " , lvl.high_score , " / " , lvl.max_score )
		
