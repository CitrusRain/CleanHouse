extends Control


func get_level_info(level_UID: int) -> Control:
	for n in get_children():
		if n.level_Unique_ID == level_UID:
			print("node ", n.level_Unique_ID)
			return n
	return null
	
