extends CharacterBody2D

@export var my_sprite: Sprite2D
@export var move_speed: float = 200.0
@export var my_path_desired_distance: float = 20
@export var my_target_desired_distance: float = 20
@export var my_nav_agent: NavigationAgent2D
@export var race_checkpoints: Array[Node2D] = [
	
]
var current_nav_target: Vector2
var checkpoint_index: int = 0
var number_of_checkpoints: int

func _ready():
	my_nav_agent.path_desired_distance = my_path_desired_distance
	my_nav_agent.target_desired_distance = my_target_desired_distance
	
	call_deferred("actor_setup")
	number_of_checkpoints = race_checkpoints.size()
	
func actor_setup():
	await get_tree().physics_frame
	set_nav_target(race_checkpoints[checkpoint_index].position)
	
	
func set_nav_target(the_target: Vector2):
	my_nav_agent.target_position = the_target
	
	
	
func _physics_process(delta):
	if checkpoint_index >= race_checkpoints.size() - 1:
		return
	
	var my_global_pos: Vector2 = global_position
	var my_next_pos: Vector2 = my_nav_agent.get_next_path_position() 
	var new_velocity: Vector2 = my_next_pos - my_global_pos
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * move_speed
	velocity = new_velocity
	handle_rotation(new_velocity)
	move_and_slide()

func handle_rotation(look_at_vector2):
	look_at(look_at_vector2)

func _on_navigation_agent_2d_target_reached():
	checkpoint_index += 1
	if checkpoint_index < race_checkpoints.size():
		set_nav_target(race_checkpoints[checkpoint_index].position)
