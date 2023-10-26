extends CharacterBody2D

##################################################
var my_name: String = "ai_car.gd"
func print_to_console(the_string: String):
	print(str(my_name, " says: ", the_string))
##################################################

signal did_a_lap

@export var my_sprite: Sprite2D
@export var move_speed: float = 200.0
@export var my_path_desired_distance: float = 20
@export var my_target_desired_distance: float = 20
@export var rotate_speed: float = 0.25
@export var my_nav_agent: NavigationAgent2D
@export var race_checkpoints: Array[Node2D] = [
	
]
var current_nav_target: Vector2
var checkpoint_index: int = 0
var my_laps: int = -1

func _ready():
	my_nav_agent.path_desired_distance = my_path_desired_distance
	my_nav_agent.target_desired_distance = my_target_desired_distance
	
	call_deferred("actor_setup")
	
	
func actor_setup():
	await get_tree().physics_frame
	set_nav_target(race_checkpoints[checkpoint_index].position)
	
	
func set_nav_target(the_target: Vector2):
	my_nav_agent.target_position = the_target
	
	
	
func _physics_process(delta):
	var my_global_pos: Vector2 = global_position
	var my_next_pos: Vector2 = my_nav_agent.get_next_path_position() 
	var new_velocity: Vector2 = my_next_pos - my_global_pos
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * move_speed
	velocity = new_velocity
	handle_rotation(new_velocity)
	move_and_slide()

func handle_rotation(look_at_vector2):
	var target_angle = look_at_vector2.angle()
	var new_angle = lerp_angle(rotation, target_angle, rotate_speed)
	new_angle -= 0
	rotation = new_angle

func _on_navigation_agent_2d_target_reached():
	checkpoint_index += 1
	if checkpoint_index < race_checkpoints.size():
		set_nav_target(race_checkpoints[checkpoint_index].position)
	else:
		checkpoint_index = 0
		set_nav_target(race_checkpoints[checkpoint_index].position)


func _on_car_trigger_area_exited(area):
	if area.name == "lap_trigger":
		my_laps += 1
		if my_laps > 0:
			did_a_lap.emit(name, my_laps)
