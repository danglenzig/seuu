extends Node2D

var player_object
var level_root
var pointer_target: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	player_object = get_parent()
	level_root = player_object.get_parent()
	pointer_target = level_root.get_node("quest_marker").position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	point_at_something(pointer_target)
	
func point_at_something(look_at_vector2):
	look_at(look_at_vector2)
	rotation += PI/2
