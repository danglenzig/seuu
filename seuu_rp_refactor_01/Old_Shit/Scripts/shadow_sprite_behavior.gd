extends Sprite2D

var player_object



@export var my_gravity = 20
@export var unit_conversion_factor = 100
@export var ramp_angle: float = 30
@export var ground_detect: float = 100
var angle_factor

var my_rotation: float
var my_root_pos: Vector2
var flippy_number = 1

var vehicle_is_airborne: bool = false
var time_since_launch: float
var velocity_at_launch: float

# Called when the node enters the scene tree for the first time.
func _ready():	## convert to rads
	ramp_angle *= (PI/180)
	angle_factor = sin(ramp_angle)
	player_object = get_parent()

func _physics_process(delta):
	rotation = player_object.get_node("PlayerSprite").get_rotation()
	if vehicle_is_airborne:
		player_object.set_linear_damp(0)
		
		visible = true
		time_since_launch += delta
		var displacement: float = 0
		var weird_var = velocity_at_launch / unit_conversion_factor
		displacement = (weird_var * angle_factor * time_since_launch) - ((time_since_launch * time_since_launch * my_gravity)/2)
#		print(displacement)
		
		position.y += displacement * 1
		position.x += displacement * 1
		
#		print(displacement)
		
		var sprite_pos = player_object.get_node("PlayerSprite").position
		var my_pos = position
		


		## if we are on the downward part of the curve and close to the ground
		if displacement < 0 and abs(my_pos.distance_to(sprite_pos)) < ground_detect:
			time_since_launch = 0
			vehicle_is_airborne = false
			player_object.is_airborne = false
	else:
		visible = false
		# handle the drag at the player object level
#		if not Input.is_action_pressed("brake"):
#			player_object.set_linear_damp(get_parent().linear_drag)
#		else:
#			player_object.set_linear_damp(player_object.linear_drag * player_object.braking_power)
		

func handle_jump_shadow():
	time_since_launch = 0
	vehicle_is_airborne = true
	player_object.is_airborne = true
	velocity_at_launch = abs(player_object.get_linear_velocity().length())





func _on_trigger_area_2d_area_exited(area):
	if area.is_in_group("eastbound_ramp"):
		if player_object.get_linear_velocity().x > 0:
			handle_jump_shadow()
	elif area.is_in_group("westbound_ramp"):
		if player_object.get_linear_velocity().x < 0:
			handle_jump_shadow()
	elif area.is_in_group("northbound_ramp"):
		if player_object.get_linear_velocity().y < 0:
			handle_jump_shadow()
	elif area.is_in_group("southbound_ramp"):
		if player_object.get_linear_velocity().y > 0:
			handle_jump_shadow()
