extends Node3D

var level_info : Control

@export var level_Unique_ID : int

@onready var high_score:= 0
@export var max_score := 2000
@onready var health_bar: TextureProgressBar = get_tree().get_first_node_in_group("HealthBar")

@onready var game_manager: Node3D = $GameManager


func _ready() -> void:
	level_info = Data.get_level_info(level_Unique_ID)
	high_score = level_info.high_score
	max_score = level_info.max_score
	health_bar.max_value = max_score
	game_manager.max = max_score

#func _process(delta: float) -> void:
	#print(health_bar.max_value)
	#health_bar.max_value = max_score
	#print(health_bar.max_value)

func packup(score: int):
	if high_score < score:
		level_info.set_score(score)
