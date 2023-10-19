# intro_cutscene.gd

extends Node2D

var shot_caller: Node
# Called when the node enters the scene tree for the first time.
func _ready():
	print("Intro cutscene!")
	shot_caller = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("continue"):
		shot_caller.switch_to_game_scene(2)
		self.queue_free()


