extends Node2D

var player_can_move: bool = true
var player_can_boost: bool = true
var player_can_brake: bool = true
var player_laps_completed: int = 0

var race_over: bool = false

@export var laps_to_win: int = 1


var player_object

var race_configs = [
	preload("res://Scenes/race_config_01.tscn"),
	preload("res://Scenes/race_config_02.tscn")
]

var race_index = 0

func _ready():
	player_object = get_node("PlayerRigidBody2D")
	var the_race_config = race_configs[race_index].instantiate()
	add_child(the_race_config)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_if_finished(player_laps_completed)
	
func _physics_process(delta):
	pass 
	
func get_player_position():
	var the_pos = player_object.position
	return the_pos
	
func check_if_finished(laps_complete):
	if laps_complete >= laps_to_win:
		race_over = true
