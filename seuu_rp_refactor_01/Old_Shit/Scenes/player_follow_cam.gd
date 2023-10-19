extends Camera2D

var shot_caller = get_parent()

var level_root
# Called when the node enters the scene tree for the first time.
func _ready():
	level_root = get_parent() # Replace with function body.


func _physics_process(delta):
	position = level_root.get_player_position()
	
