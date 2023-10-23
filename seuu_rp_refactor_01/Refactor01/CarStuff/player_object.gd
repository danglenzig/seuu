extends RigidBody2D
##################################################
var my_name: String = "player_object.gd"
func print_to_console(the_string: String):
	print(str(my_name, " says: ", the_string))
##################################################

enum ControlsMode {XONLY, XY}



var shot_caller

var controls_mode: ControlsMode = ControlsMode.XONLY
@export var alt_controls: bool = false

@export var boost_dampening: float = 0.5

signal right_action
signal left_action

var my_sprite: Sprite2D
var my_rof_timer: Timer

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
var my_armor_rating: float
var my_rate_of_fire: float

## status info
var current_max_speed: float
var is_airborne: bool
var can_move: bool
var can_rotate: bool
var can_boost: bool
var can_brake: bool
var can_fire: bool
var is_trapable: bool = true

var weapon_01
var weapon_02

func _ready():
	shot_caller = get_tree().get_current_scene()
	my_sprite = get_node("CarSprite")
	my_rof_timer = get_node("rof_timer")
	
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
	my_armor_rating = my_car_data.armor_rating
		
	current_max_speed = my_start_max_speed
	boost_dampening = 1 - boost_dampening
	is_airborne = false
	can_move = true
	can_rotate = true
	can_boost = true
	can_brake = true
	can_fire = true
	
	set_linear_damp(my_linear_drag)
	
	
	weapon_01 = get_node("weapon_01")
	weapon_02 = get_node("weapon_02")
	my_rate_of_fire = weapon_01.rate_of_fire
	my_rof_timer.set_wait_time(1 / my_rate_of_fire)
	
	if alt_controls == true:
		shot_caller.set_alt_controls_help(true)
	elif alt_controls == false:
		shot_caller.set_alt_controls_help(false)


func _process(delta):
	pass
	
func _physics_process(delta):
	
	if controls_mode == ControlsMode.XY:
		handle_rb_movement()
		handle_sprite_rotation()
		handle_rb_boost()
		
	if controls_mode == ControlsMode.XONLY:
		if alt_controls == false:
			handle_xonly_controls()
		elif alt_controls == true:
			handle_alt_controls()
		handle_action_input()
		handle_rb_brakes()
	handle_explore_telemetry()
	
	
	
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
	if alt_controls == false:
		if Input.is_action_just_pressed("item_action_01"):
			left_action.emit()
		if Input.is_action_just_pressed("item_action_02"):
			right_action.emit()
	elif alt_controls == true:
		if Input.is_action_just_pressed("alt_item_action_01"):
			left_action.emit()
		if Input.is_action_just_pressed("alt_item_action_02"):
			right_action.emit()

func handle_left_action():
	# here, check to see wh0at action is on LT,
	# but for now, just...
	drop_a_trap()
	
func handle_right_action():
	# here, check to see wh0at action is on RT,
	# but for now, just...
	fire_projectile()
	
func drop_a_trap():
	weapon_02.drop_a_trap()
	
func fire_projectile():
	if can_fire:
		can_fire = false
		my_rof_timer.start()
		weapon_01.activate()

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
	


func handle_explore_telemetry():
	var my_speed = abs(get_linear_velocity().length())
	my_speed *= 0.1
	my_speed = snappedf(my_speed, 1.0)
#	shot_caller.show_speed(my_speed)
	
func get_sprite_rotation():
	var the_rot = my_sprite.rotation
	return the_rot

##########################


func _on_left_action():
	handle_left_action()


func _on_right_action():
	handle_right_action()


func _on_car_trigger_body_entered(body):
	pass


func _on_rof_timer_timeout():
	can_fire = true


func _on_car_trigger_area_entered(the_trap):
	if the_trap.is_in_group("trap"):
		if is_trapable:
			the_trap.splode()
		
