extends Node2D

##################################################
var my_name: String = "refactor01_explore_level.gd"
func print_to_console(the_string: String):
	print(str(my_name, " says: ", the_string))
##################################################

var shot_caller: Node
@export var follow_cam: Camera2D
@export var player_object: RigidBody2D
@export var player_start: Marker2D

# Called when the node enters the scene tree for the first time.
func _ready():
	shot_caller = get_parent()
	print_to_console("You are now in an explore mode level")
	player_object.position = player_start.position
	
	shot_caller.set_explore_hud_panel_visible(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_follow_cam()
	
func handle_follow_cam():
	follow_cam.position = player_object.position
