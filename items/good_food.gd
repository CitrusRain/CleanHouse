extends pickup
#class_name PerishableFood

@onready var expire_timer: Timer = $ExpireTimer

func _ready() -> void:
	if $Label3D.text == "#":
		$Label3D.text = str(pickup_type)
	#$Label3D.visible = false
	var item_name = ""
	if $Options:
		var options = $Options.get_children()
		for option in options:
			option.visible = false
			item_name = option.name
		options[randi() % options.size()].visible = true
		for option in options:
			if option.visible == false:
				option.queue_free()
		for option in $BadOptions:
			if option.name != item_name:
				option.queue_free()
			else:
				option.visible = false
				option.reparent($Options)

func _process(delta: float) -> void:
	if general_functions.get_grandparent(self).name != "Refrigerator" and expire_timer.is_stopped():
		expire_timer.start()
	if move_to_inventory:
		reparent(player_body.get_node("PlayerInventory"))
		move_to_inventory = false

func _on_expire_timer_timeout() -> void:
	for option in $Options:
		option.visible = not option.visible
