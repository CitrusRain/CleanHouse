extends Control

@onready var game_over_screen: CenterContainer = $GameOverScreen

@export var unhandled_item_template: PackedScene
@export var mishandled_item_template: PackedScene
@onready var final_score_label: Label = $GameOverScreen/PanelContainer/VBoxContainer/FinalScoreLabel
@onready var health_bar: TextureProgressBar = $HUD/VBoxContainer/HealthArea/HealthBar

var score := 0

func _on_game_over_screen_visibility_changed() -> void:
	if game_over_screen:
		get_tree().paused = game_over_screen.visible
	pass # Replace with function body.

func report_unhandled_item(item: pickup):
	var foo = unhandled_item_template.instantiate()
	add_child(foo)
	if item.get_node("Options"):
		foo.get_node("ItemImage").texture = item.get_node("Options").get_child(0).texture
	foo.get_node("ItemName").text = foo.get_node("ItemImage").texture.get_path().get_file().capitalize().get_basename() #str(item.pickup_type)
	foo.get_node("Deduction").text = str("-",item.lose_points)
	foo.reparent(get_tree().get_first_node_in_group("clutter_vbox"))
	score += item.lose_points
	pass

func report_mishandled_item(_image: Texture2D, item: pickup, container_name: String ):
	var foo = mishandled_item_template.instantiate()
	add_child(foo)
	#foo.get_node("LocationImage").texture = _image.texture
	if item.get_node("Options"):
		foo.get_node("ItemImage").texture = item.get_node("Options").get_child(0).texture
	foo.get_node("ItemName").text = foo.get_node("ItemImage").texture.get_path().get_file().capitalize().get_basename() #str(item.pickup_type)
	foo.get_node("Deduction").text = str("-",item.trashed_penalty)
	var cn = foo.get_node("ContainerName")
	cn.text = container_name
	foo.reparent(get_tree().get_first_node_in_group("trash_vbox"))
	score += item.trashed_penalty
	pass



func final_score()-> int:
	final_score_label.text = str(( int(health_bar.max_value) - score) , "/", int(health_bar.max_value))
	return  int(health_bar.max_value) - score


func _on_main_menu_pressed() -> void:
	#/root/MainMenu/LevelList/LevelButton
	#res://user_interface/main_menu.tscn
	get_tree().paused = false
	get_tree().change_scene_to_file("res://user_interface/main_menu.tscn")
	pass # Replace with function body.


func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
