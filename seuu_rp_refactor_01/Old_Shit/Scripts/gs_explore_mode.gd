extends Node2D

var player_can_move: bool = true
var player_can_boost: bool = true
var player_can_brake: bool = true

var explore_canvas_layer
var start_race_panel

func _ready():
	var player_start = get_node("player_start")
	var player_object = get_node("PlayerRigidBody2D")
	explore_canvas_layer = get_node("ExploreCanvasLayer")
	start_race_panel = explore_canvas_layer.get_node("start_race_panel")
	start_race_panel.visible = false
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_player_position():
	var the_pos = get_node("PlayerRigidBody2D").position
	return the_pos
	
