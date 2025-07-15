extends Control

@onready var game_over_screen: CenterContainer = $GameOverScreen

@export var unhandled_item_template: PackedScene
@export var mishandled_item_template: PackedScene
@onready var final_score_label: Label = $GameOverScreen/PanelContainer/VBoxContainer/FinalScoreLabel

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
	foo.get_node("Deduction").text = str("-",item.lose_points)
	var cn = foo.get_node("ContainerName")
	cn.text = container_name
	foo.reparent(get_tree().get_first_node_in_group("trash_vbox"))
	score += item.lose_points
	pass


func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func final_score(max_score: int):
	final_score_label.text = str((max_score - score) , "/", max_score)
