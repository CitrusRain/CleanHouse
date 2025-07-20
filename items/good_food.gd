extends pickup
class_name PerishableFood

@onready var expire_timer: Timer = $ExpireTimer
@export var bad_loose_points:= 150

var expiration_time = 10 + (randi() % 30)
@export var expired = false

func _ready() -> void:	
	if $Label3D.text == "#":
		$Label3D.text = str(pickup_type)
	#$Label3D.visible = false
	var item_name = ""
	if $Options:
		var options = $Options.get_children()
		for option in options:
			option.visible = false
		var random_index = randi() % options.size()
		item_name = options[random_index].name
		options[random_index].visible = true
		for option in options:
			if option.visible == false:
				option.queue_free()
		for option in $BadOptions.get_children():
			if option.name != item_name:
				option.queue_free()
			else:
				option.visible = false
				option.reparent($Options)

func _process(_delta: float) -> void:
	if general_functions.get_grandparent(self).name != "Refrigerator" and expire_timer.is_stopped() and not expired:
		if expire_timer.paused == false:
			expire_timer.start()
		else:
			expire_timer.paused = false
	elif general_functions.get_grandparent(self).name == "Refrigerator":
		expire_timer.paused = true
	if move_to_inventory:
		reparent(player_body.get_node("PlayerInventory"))
		move_to_inventory = false

func _on_expire_timer_timeout() -> void:
	for option in $Options.get_children():
		if option.visible:
			option.queue_free()
		else:
			option.visible = true
	$Label3D.text = "Bad Food"
	pickup_type = general_functions.item_types.BAD_FOOD
	lose_points = bad_loose_points
	expired = true
