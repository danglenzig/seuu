extends Node2D

var shot_caller
var screen_wiper

# Called when the node enters the scene tree for the first time.
func _ready():
	shot_caller = get_tree().current_scene
	screen_wiper = shot_caller.get_node("CanvasLayer/ScreenWiper")
	screen_wiper.play_wipe()
	shot_caller.set_race_hud_panel_visible(true)
	shot_caller.set_race_mode_center_text("Race #1\nComing soon!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
