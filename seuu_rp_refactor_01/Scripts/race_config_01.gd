extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var player_start = get_node("player_start")
	var player_object = get_parent().get_node("PlayerRigidBody2D")
	player_object.position = player_start.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
