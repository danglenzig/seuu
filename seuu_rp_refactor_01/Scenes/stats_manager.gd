extends Node2D

var vehicle

func _ready():
	vehicle = get_parent()


func _process(delta):
	pass
	
func take_damage(the_damage):

	vehicle.current_health -= the_damage
	var health_ui_text_label = vehicle.hud_canvas.get_node("HealthText")
	health_ui_text_label.set_text(str("Health: ", str(vehicle.current_health)))
	
	
	## check if dead
	if vehicle.current_health < 0:
		vehicle.current_health = 0
		health_ui_text_label.set_text(str("Health: ", str(vehicle.current_health)))
		vehicle.level_root.player_can_move = false
		vehicle.vfx_handler.play_splode_effect()
		vehicle.sprite_flash_timer.start()
		vehicle.die_timer.start()
		
		
#	health_text.set_text(str("Health: ", str(current_health)))
