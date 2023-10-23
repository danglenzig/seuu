extends Sprite2D

##################################################
var my_name: String = "shadow_sprite_2d.gd"
func print_to_console(the_string: String):
	print(str(my_name, " says: ", the_string))
##################################################

@export var my_gravity = 20
@export var unit_conversion_factor = 100
@export var ramp_angle: float = 30
@export var ground_detect: float = 100

@export var car_sprite: Sprite2D
var car_rb: RigidBody2D

var angle_factor

var my_rotation: float
var my_root_pos: Vector2
var flippy_number = 1

var vehicle_is_airborne: bool = false
var time_since_launch: float
var velocity_at_launch: float


func _process(delta):
	if car_rb.is_airborne == true:
		visible = true
	else:
		visible = false


func _ready():
	ramp_angle *= (PI/180) # rads
	angle_factor = sin(ramp_angle)
	car_rb = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rotation = car_sprite.rotation
	if car_rb.is_airborne:
		time_since_launch += delta
		var displacement: float = 0
		var weird_var = velocity_at_launch / unit_conversion_factor
		displacement = (weird_var * angle_factor * time_since_launch) - ((time_since_launch * time_since_launch * my_gravity) / 2)
		position.x += displacement * 1
		position.y += displacement * 1
		
		var sprite_pos = car_sprite.position
		var my_pos = position
		## if we are on the downward part of the curve and close to the ground
		if displacement < 0 and abs(my_pos.distance_to(sprite_pos)) < ground_detect:
			time_since_launch = 0
			vehicle_is_airborne = false
			car_rb.is_airborne = false
	
	
func handle_shadow():
	time_since_launch = 0
#	vehicle_is_airborne = true
	car_rb.is_airborne = true
	velocity_at_launch = abs(car_rb.get_linear_velocity().length())


func _on_car_trigger_area_exited(area):
	if area.is_in_group("ramp"):
		handle_shadow()
		
	
