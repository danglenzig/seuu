extends Camera2D
@export var player_object: RigidBody2D
@export var prediction_strength: float = 0.5
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	handle_follow_cam()


func handle_follow_cam():
	var player_velocity = player_object.get_linear_velocity()
	player_velocity.y *= prediction_strength
	player_velocity.x *= prediction_strength * (16 / 9)
	var forward_pos = player_object.position + player_velocity
	var camera_pos = (player_object.position + forward_pos) / 2
	position = camera_pos
