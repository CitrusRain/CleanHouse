class_name WireSource 
extends WireSegment


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	next_wire = WireSegment.new()
	next_wire.prev_wire = self
	add_child(next_wire)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
