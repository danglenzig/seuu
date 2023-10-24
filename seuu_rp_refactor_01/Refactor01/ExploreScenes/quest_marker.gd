extends Node2D
var shot_caller

# Called when the node enters the scene tree for the first time.
func _ready():
	shot_caller = get_tree().current_scene
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("player_object"):
		shot_caller.switch_to_race_scene(0)
