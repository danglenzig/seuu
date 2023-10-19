extends Node2D

##################################################
var my_name: String = "refactor01_start_screen.gd"
func print_to_console(the_string: String):
	print(str(my_name, " says: ", the_string))
##################################################

var shot_caller

func _ready():
	print_to_console("Hi I'm the start screen")
	shot_caller = get_parent()
	shot_caller.set_cutscene_hud_panel_visible(true)
	var title_slide = load("res://Slides/Title.png")
	shot_caller.set_cutscene_slide(title_slide)
	shot_caller.set_cutscene_prompt_text("Press space to continue")


func _process(delta):
	if Input.is_action_just_pressed("continue"):
		shot_caller.set_cutscene_hud_panel_visible(false)
		shot_caller.switch_to_cutscene(1)
