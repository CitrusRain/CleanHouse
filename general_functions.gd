extends Node
class_name general_functions

enum item_types { WILD, TOY, DIRT, TRASH, DOG_POOP, DOG_TOY, JEWELRY, BAD_FOOD } 

static func get_grandparent(n) -> Node:
	return n.get_parent().get_parent()
	
static func get_great_grandparent(n) -> Node:
	return n.get_parent().get_parent().get_parent()


#From FencerDevLog https://forum.godotengine.org/t/how-do-i-get-all-nodes-from-a-scene/49088
static func get_all_children(in_node, array := []):
	array.push_back(in_node)
	for child in in_node.get_children():
		array = get_all_children(child, array)
	return array
