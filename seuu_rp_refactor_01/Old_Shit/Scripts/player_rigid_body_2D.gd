# player_rigid_body

extends RigidBody2D

enum DriveMode {RACE, EXPLORE}
enum InputMode {VEHICLE, UI}



var quest_marker


var current_drive_mode: DriveMode
var current_input_mode: InputMode
# player for impact one-shot sfx
var impact_sfx_player: AudioStreamPlayer
var impact_sfx_ogg: AudioStream
var wipeout_sfx_ogg: AudioStream

# loop of the engine sound
# this player will be on continuously
var motor_sfx_player: AudioStreamPlayer
var motor_sfx_ogg: AudioStream

## a resource .gd file containing the current car's data
var car_data: Resource
var vehicle_name: String
var move_speed: float
var start_max_speed: float
var rotate_speed: float
var linear_drag: float
var xy_slerp_factor: float
var boost_factor: float
var braking_power: float
var max_health: float
var damage_per_hit: float

# runtime variables
var max_speed: float
var current_health: float
var can_move: bool = true
var can_brake: bool = true
var can_boost: bool = true
var can_aim: bool = true
var is_airborne: bool = false
var next_race: int = 0

# grandparent node -- the game's shot-caller
var shot_caller: Node

#parent node -- the root of the current level
var level_root: Node2D

var laps_this_race: int ##get from the level root node
var laps_completed: int = 0

var sprite_flash_timer ## a child node
var die_timer
var vfx_handler
var stats_manager

# sprites
var my_sprite: Sprite2D
#var accelerate_effect_sprite: Sprite2D
#var spark_fx_anim: AnimatedSprite2D
#var splode_fx_anim: AnimatedSprite2D
var gun_sprite: Sprite2D
var start_move_speed: float

# misc
@export var impact_sfx_volume_db: float = -10
@export var engine_sfx_loop_volume_db = -10

# get the UI
var hud_canvas
var my_pointer

func _ready():
	level_root = get_parent() ## this is the city map
	current_input_mode = InputMode.VEHICLE
	var explore_string = "explore"
	var race_string = "race"
	if race_string in level_root.name:
		current_drive_mode = DriveMode.RACE
	elif explore_string in level_root.name:
		current_drive_mode = DriveMode.EXPLORE
	else:
		current_drive_mode = DriveMode.EXPLORE
	print(current_drive_mode)
	
	
	shot_caller = level_root.get_parent() ## this is the shot caller
	# get the data for the current car
	car_data = load("res://InfoFiles/car_01_data.gd").new()
	vehicle_name = car_data.vehicle_name
	move_speed = car_data.move_speed
	start_move_speed = move_speed
	start_max_speed = car_data.start_max_speed
	max_speed = start_max_speed
	rotate_speed = car_data.rotate_speed
	linear_drag = car_data.linear_drag
	xy_slerp_factor = car_data.xy_slerp_factor
	boost_factor = car_data.boost_factor
	braking_power= car_data.braking_power
	max_health = car_data.max_health
	damage_per_hit = car_data.damage_per_hit
	
	
	
	current_health = max_health
	
	# set up the impact sfx player
	impact_sfx_player = AudioStreamPlayer.new()
	add_child(impact_sfx_player)
	impact_sfx_player.set_volume_db(impact_sfx_volume_db)
#	impact_sfx_ogg = load("res://SOUND/SFX/impact_01.ogg")
#	wipeout_sfx_ogg = load("res://SOUND/SFX/crash_01.ogg")
#	impact_sfx_player.set_stream(impact_sfx_ogg)
	
	# set up the engine sound loop player
	motor_sfx_player = AudioStreamPlayer.new()
	add_child(motor_sfx_player)
	motor_sfx_player.set_volume_db(engine_sfx_loop_volume_db)
#	motor_sfx_ogg = load("res://SOUND/SFX/idle_engine_01.ogg")
#	motor_sfx_player.set_stream(motor_sfx_ogg)

	#set up the flash timer
	sprite_flash_timer = get_node("SpriteFlashTimer")
	die_timer = get_node("DieTimer")



	# sprites
	my_sprite = get_node("PlayerSprite")
	my_pointer = get_node("Pointer")
	
	# misc
	set_linear_damp(linear_drag)
	
	# get race info
	if current_drive_mode == DriveMode.RACE:
		laps_this_race = level_root.laps_to_win
	else:
		laps_this_race = 0
	
	# get a reference to the ra race HUD
	
	if current_drive_mode == DriveMode.RACE:
		hud_canvas = level_root.get_node("HUDCanvasLayer")
		var health_text = hud_canvas.get_node("HealthText")
		var laps_text = hud_canvas.get_node("LapsText")
		health_text.set_text(str("Health: ", str(current_health)))
		laps_text.set_text(str("Laps: ", str(laps_completed), " / ", laps_this_race))
	
	vfx_handler = my_sprite.get_node("vfx_handler")
	stats_manager = get_node("stats_manager")
	
	
	quest_marker = level_root.get_node("quest_marker")
	
	if current_drive_mode == DriveMode.RACE:
		my_pointer.visible = false

func _process(delta):
	
	can_move = level_root.player_can_move
	can_brake = level_root.player_can_brake
	can_boost = level_root.player_can_boost
	
#	my_pointer.point_at_something(quest_marker.position)

	if current_drive_mode == DriveMode.EXPLORE:
		var point_pos = quest_marker.get_global_position()
		my_pointer.point_at_something(point_pos)
	
	if current_drive_mode == DriveMode.RACE:
		check_if_finished()
	

func _physics_process(delta):
	if current_input_mode == InputMode.VEHICLE:
		if can_move:
			handle_movement(get_move_input_v2())
			handle_boost()
	if current_input_mode == InputMode.UI:
		if Input.is_action_just_pressed("continue"):
			shot_caller.start_race(next_race)
			level_root.queue_free()
			##load the race scene

func handle_start_race():
	pass

func get_move_input_v2():
	
	var the_input: Vector2 = Vector2.ZERO
	
	# left-right
	if Input.is_action_pressed("player_move_right"):
		the_input.x = 1
	elif Input.is_action_pressed("player_move_left"):
		the_input.x = -1
	else:
		the_input.x = 0
		
	if Input.is_action_pressed("player_move_down"):
		the_input.y = 1
	elif Input.is_action_pressed("player_move_up"):
		the_input.y = -1
	else:
		the_input.y = 0
	
	return the_input

func handle_movement(the_move_input):
	
	# do some math
	the_move_input = the_move_input.normalized()
	var current_velocity = abs(self.get_linear_velocity().length())
	var move_force = 1 - (current_velocity / max_speed)
	move_force *= move_speed
	
	# move that ass
	if not is_airborne and can_move:
		if abs(the_move_input.length()) > 0:
			set_linear_damp(car_data.move_drag)
		else:
			set_linear_damp(linear_drag)
		self.apply_central_force(the_move_input * move_force)
		
	## rotate that ass
	var target_angle = the_move_input.angle()
	var current_angle = my_sprite.rotation	
	var new_angle = lerp_angle(current_angle,target_angle,xy_slerp_factor)
	var input_length = abs(the_move_input).length()
	if input_length > 0 and not is_airborne:
		
		my_sprite.rotation = new_angle

func handle_boost():
	if Input.is_action_pressed("boost"):
		move_speed = start_move_speed * boost_factor
		max_speed = start_max_speed * boost_factor
		var current_rotation = my_sprite.rotation
		var forward_direction = Vector2(1, 0).rotated(current_rotation)
		self.apply_central_force(forward_direction * move_speed * .33)
		vfx_handler.play_accelerate_effect(true)
	else:
		move_speed = start_move_speed
		max_speed = start_max_speed
		vfx_handler.play_accelerate_effect(false)



		

func toggle_sprite_visibility():
	my_sprite.visible = not my_sprite.visible

func _on_sprite_flash_timer_timeout():
	toggle_sprite_visibility()


func _on_trigger_area_2d_area_exited(area):
	var my_string = "lap_counter"
	if my_string in area.name:
		laps_completed += 1
		var laps_text = hud_canvas.get_node("LapsText")
		laps_text.set_text(str("Laps: ", str(laps_completed), " / ", laps_this_race))
		level_root.player_laps_completed = laps_completed
		

func start_race_sequence(the_race_id):
	print(str("Race ID ", the_race_id))
	level_root.start_race_panel.visible = true
	current_input_mode = InputMode.UI
	level_root.player_can_move = false
	freeze = true
	next_race = the_race_id
	
	
func go_back_to_explore_mode():
	shot_caller.switch_to_game_scene(2)
	level_root.queue_free()

func _on_die_timer_timeout():
	go_back_to_explore_mode()
	
func _on_trigger_area_2d_body_entered(body):
	
	var my_string = "barricade"
	if my_string in body.name:
		if current_drive_mode == DriveMode.RACE:
			stats_manager.take_damage(damage_per_hit)
		vfx_handler.play_impact_effect(my_string)
		
	my_string = "street_collider"
	if my_string in body.name:
		if current_drive_mode == DriveMode.RACE:
			stats_manager.take_damage(damage_per_hit)
		vfx_handler.play_impact_effect(my_string)
		
	my_string = "boundary"
	if my_string in body.name:
		if current_drive_mode == DriveMode.RACE:
			stats_manager.take_damage(damage_per_hit)
		vfx_handler.play_impact_effect(my_string)


func _on_trigger_area_2d_area_entered(area):
	if current_drive_mode == DriveMode.EXPLORE:
		var my_string = "race_start_trigger"
		if my_string in area.name:
			start_race_sequence(area.race_id)
			
			
func check_if_finished():
	if level_root.race_over == true:
		go_back_to_explore_mode()



