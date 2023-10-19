extends RigidBody2D
##################################################
var my_name: String = "player_object.gd"
func print_to_console(the_string: String):
	print(str(my_name, " says: ", the_string))
##################################################

enum  ControlsMode {XONLY, XY}
@export var controls_mode: ControlsMode

@export var boost_dampening: float = 0.5

var my_sprite: Sprite2D
var my_shadow: Sprite2D

## declare the car data
var my_car_data: Resource
var my_vehicle_name
var my_move_speed: float
var my_start_max_speed: float
var my_rotate_speed: float
var my_linear_drag: float
var my_move_drag: float
var my_xy_slerp_factor: float
var my_boost_factor: float
var my_braking_power: float
var my_max_health: float
var my_damage_per_hit: float

## status info
var current_max_speed: float
var is_airborne: bool
var can_move: bool
var can_rotate: bool
var can_boost: bool
var can_brake: bool

func _ready():
	
	my_sprite = get_node("CarSprite")
	my_shadow = get_node("ShadowSprite")
	
	## load the car data
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
	my_max_health = my_car_data.max_health
	my_damage_per_hit = my_car_data.damage_per_hit
	
	current_max_speed = my_start_max_speed
	boost_dampening = 1 - boost_dampening
	is_airborne = false
	can_move = true
	can_rotate = true
	can_boost = true
	can_brake = true
	
	set_linear_damp(my_linear_drag)
	
	




func _process(delta):
	pass
	
func _physics_process(delta):
	
	if controls_mode == ControlsMode.XY:
		handle_rb_movement()
		handle_sprite_rotation()
		handle_rb_boost()
		
	if controls_mode == ControlsMode.XONLY:
		
		handle_xonly_controls()
		
		
		handle_rb_brakes()
		
	handle_shadow()
	
	
	
func handle_move_input():
	var move_input_v2: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("player_move_right"):
		move_input_v2.x = 1
	elif Input.is_action_pressed("player_move_left"):
		move_input_v2.x = -1
	else:
		move_input_v2.x = 0
		
	if Input.is_action_pressed("player_move_up"):
		move_input_v2.y = -1
	elif Input.is_action_pressed("player_move_down"):
		move_input_v2.y = 1
	else:
		move_input_v2.y = 0
	
	return move_input_v2
	

func handle_boost_input():
	var boost_input: bool
	if Input.is_action_pressed("boost"):
		boost_input = true
	else:
		boost_input = false
	return boost_input
	
func handle_action_input():
	pass



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
			
func xonly_steering():
	var steer_input: float = Input.get_axis("player_move_left", "player_move_right")
	print_to_console(str(steer_input))
	var move_input: float = 0
	if Input.is_action_pressed("go"):
		move_input += 1
	elif Input.is_action_pressed("stop"):
		move_input -= 1
	if move_input != 0:
		my_sprite.rotation += my_rotate_speed * steer_input
	elif abs(get_linear_velocity().length()) > 100:
		my_sprite.rotation += my_rotate_speed * steer_input
	
	
func handle_rb_movement():
	var the_move_input: Vector2 = handle_move_input()
	var current_speed = abs(get_linear_velocity().length())
	var move_force = 1 - (current_speed / current_max_speed) 
	move_force *= my_move_speed
	if not is_airborne:
		if can_move:
			self.apply_central_force(the_move_input * move_force)
	
func handle_sprite_rotation():
	var the_move_input: Vector2 = handle_move_input()
	var target_angle = the_move_input.angle()
	var current_angle = my_sprite.rotation
	var new_angle = lerp_angle(current_angle,target_angle,my_xy_slerp_factor)
	if not is_airborne:
		if can_rotate:
			if abs(the_move_input.length()) > 0:
				my_sprite.rotation = new_angle
	
	
func handle_rb_boost():
	if handle_boost_input() == true:
		if can_boost == true:
			var boost_force = my_move_speed * my_boost_factor 
			current_max_speed = my_start_max_speed * my_boost_factor
			var current_rotation = my_sprite.rotation
			var local_forward = Vector2(1,0).rotated(current_rotation)
			self.apply_central_force(local_forward * boost_force * boost_dampening)
	else:
		current_max_speed = my_start_max_speed

func handle_rb_brakes():
	pass
	
func handle_shadow():
	my_shadow.rotation = my_sprite.rotation
