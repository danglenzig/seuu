extends RigidBody2D

@export var alt_controls: bool = false

var my_car_data

var my_vehicle_name
var my_move_speed: float
var my_start_max_speed: float
var my_rotate_speed: float
var my_linear_drag: float
var my_move_drag: float
var my_xy_slerp_factor: float
var my_boost_factor: float
var my_braking_power: float

var current_max_speed: float

var is_airborne: bool = false
var can_move: bool = true

@export var my_sprite: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	my_car_data = load("res://Old_Shit/InfoFiles/car_01_data.gd").new()
	my_car_data = load("res://Refactor01/InfoFiles/car_info_01.gd").new()
	my_vehicle_name = my_car_data.vehicle_name
	my_move_speed = my_car_data.move_speed
	my_start_max_speed = my_car_data.start_max_speed
	my_rotate_speed = my_car_data.rotate_speed
	my_linear_drag = my_car_data.linear_drag
	my_move_drag = my_car_data.move_drag
	my_xy_slerp_factor = my_car_data.xy_slerp_factor
	my_boost_factor = my_car_data.boost_factor
	my_braking_power = my_car_data.braking_power
	
	current_max_speed = my_start_max_speed
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if alt_controls == false:
		handle_xonly_controls()
	elif alt_controls == true:
		handle_alt_controls()
		

	

func handle_xonly_controls():
	var current_speed = abs(get_linear_velocity().length())
	var move_force = 1 - (current_speed / current_max_speed)
	move_force *= my_move_speed
	if not is_airborne:
		if can_move:
			if Input.is_action_pressed("go"):
				set_linear_damp(my_linear_drag)
				var current_rotation = my_sprite.rotation
				var local_forward = Vector2(1,0).rotated(current_rotation)
				self.apply_central_force(local_forward * move_force)
			elif Input.is_action_pressed("stop"):
				set_linear_damp(my_linear_drag * my_braking_power)
				var current_rotation = my_sprite.rotation
				var local_forward = Vector2(1,0).rotated(current_rotation)
				self.apply_central_force(local_forward * -move_force * 0.33)
			else:
				set_linear_damp(my_linear_drag)
			xonly_steering()
	else:
		## if i am airborne..
		set_linear_damp(0)		
func xonly_steering():
	var steer_input: float = Input.get_axis("player_move_left", "player_move_right")
	var move_input: float = 0
	if Input.is_action_pressed("go"):
		move_input += 1
	elif Input.is_action_pressed("stop"):
		move_input -= 1
	if move_input != 0:
		my_sprite.rotation += my_rotate_speed * steer_input
	elif abs(get_linear_velocity().length()) > 100:
		my_sprite.rotation += my_rotate_speed * steer_input
	
func handle_alt_controls():
	var current_speed = abs(get_linear_velocity().length())
	var move_force = 1 - (current_speed / current_max_speed)
	move_force *= my_move_speed
	if not is_airborne:
		if can_move:
			if Input.is_action_pressed("alt_go"):
				set_linear_damp(my_linear_drag)
				var current_rotation = my_sprite.rotation
				var local_forward = Vector2(1,0).rotated(current_rotation)
				self.apply_central_force(local_forward * move_force)
			elif Input.is_action_pressed("alt_stop"):
				set_linear_damp(my_linear_drag * my_braking_power)
				var current_rotation = my_sprite.rotation
				var local_forward = Vector2(1,0).rotated(current_rotation)
				self.apply_central_force(local_forward * -move_force * 0.33)
			else:
				set_linear_damp(my_linear_drag)
			xonly_steering()
	else:
		## if i am airborne..
		set_linear_damp(0)
