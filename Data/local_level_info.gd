extends Node3D

var level_info : Control

@export var level_Unique_ID : int

@onready var high_score:= 0
@onready var max_score := 0
@onready var health_bar: TextureProgressBar = get_tree().get_first_node_in_group("HealthBar")

@onready var game_manager: Node3D = $GameManager


func _ready() -> void:
	#Make sure LevelRoot node and Data's entry for the level have the same UID
	level_info = Data.get_level_info(level_Unique_ID)
	# OR WILL CRASH OR JUST MESS UP SCORES
	
	high_score = level_info.high_score
	max_score = level_info.max_score
	health_bar.max_value = max_score
	game_manager.maxx = max_score

#func _process(delta: float) -> void:
	#print(health_bar.max_value)
	#health_bar.max_value = max_score
	#print(health_bar.max_value)

func packup(score: int):
	if high_score < score:
		level_info.set_score(score)
