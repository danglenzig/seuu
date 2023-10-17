# start_menu.gd

extends Node2D

var shot_caller

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Start menu!")
	shot_caller = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	play_intro_cutscene()
	
func play_intro_cutscene():
	if  Input.is_action_just_pressed("continue"):
		shot_caller.switch_to_game_scene(1)
		self.queue_free()
		
