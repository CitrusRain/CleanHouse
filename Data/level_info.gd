extends Control

@export_file("*.tscn") var level_file
@export var level_Unique_ID : int

@onready var high_score:= 0
@export var max_score := 2000

@export var passing_score := 500
@onready var passed := false

func get_score() -> String:
	return str(high_score , " / " , max_score)
	
func set_score(new_score: int):
	high_score = max(new_score,high_score)
	passed = (high_score >= passing_score)
