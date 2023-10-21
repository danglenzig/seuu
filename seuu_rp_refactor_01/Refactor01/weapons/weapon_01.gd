extends Node2D
##################################################
var my_name: String = "weapon_01.gd"
func print_to_console(the_string: String):
	print(str(my_name, " says: ", the_string))
##################################################
var shot_caller
var level_map
var vehicle_object
var vehicle_sprite
var my_projectile
@export var launch_power: float = 30
@export var rate_of_fire: float = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	shot_caller = get_tree().get_current_scene()
	vehicle_object = get_parent()
	level_map = vehicle_object.get_parent()
	vehicle_sprite = vehicle_object.get_node("CarSprite")
	my_projectile = preload("res://Refactor01/weapons/projectile_01.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position = vehicle_sprite.position
	rotation = vehicle_sprite.rotation

func activate():
	var new_projectile = my_projectile.instantiate()
	level_map.add_child(new_projectile)
	var local_forward = Vector2(1,0).rotated(rotation)
	new_projectile.rotation = vehicle_sprite.rotation
	new_projectile.position = vehicle_sprite.get_global_position()
	new_projectile.set_linear_damp(0)
	new_projectile.apply_central_impulse(local_forward * launch_power)
