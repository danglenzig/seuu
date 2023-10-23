extends Node2D

@export var weapon_name: String = "Basic Trap"
@export var launch_offset: float = 30.0
var car_object
var level_map

var trap_file = preload("res://Refactor01/weapons/trap_01.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	car_object = get_parent()
	level_map = car_object.get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func drop_a_trap():
	## put the trap directly behind (local)
	## the player sprite
	var car_sprite = get_parent().get_node("CarSprite")
	var behind_the_car_sprite_pos: Vector2
	behind_the_car_sprite_pos = car_object.position
	var local_behind = Vector2(-launch_offset,0).rotated(car_sprite.rotation)
	local_behind += behind_the_car_sprite_pos
	
	var a_new_trap = trap_file.instantiate()
	level_map.add_child(a_new_trap)
	a_new_trap.position = local_behind
	print(a_new_trap.position)
	
	
