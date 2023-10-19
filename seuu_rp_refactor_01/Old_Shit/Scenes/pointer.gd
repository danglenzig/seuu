extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func point_at_something(look_at_vector2):
	look_at(look_at_vector2)
	rotation += PI/2
