extends Node2D

##################################################
var my_name: String = "refactor01_cutscene01.gd"
func print_to_console(the_string: String):
	print(str(my_name, " says: ", the_string))
##################################################

var shot_caller

var my_slides = [
	preload("res://Slides/i_am_a_cutscene_01.png"),
	preload("res://Slides/i_am_a_cutscene_02.png")
]
var current_slide_number = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	shot_caller = get_parent()
	shot_caller.set_cutscene_hud_panel_visible(true)
	shot_caller.set_cutscene_slide(my_slides[current_slide_number])
	shot_caller.set_cutscene_prompt_text("Press space to continue")
	
	print_to_console("Hi I'm the first cutscene")
	print_to_console(str("here is cutscene01, slide number ", current_slide_number))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("continue"):
		advance_the_cutscene()
	
func advance_the_cutscene():
	current_slide_number += 1
	if current_slide_number >= my_slides.size():
		print_to_console("the end of the cutscene is reached")
		shot_caller.set_cutscene_hud_panel_visible(false)
		shot_caller.switch_to_explore_scene(0)
		
	else:
		print_to_console(str("here is cutscene01, slide number ", current_slide_number))
		shot_caller.set_cutscene_slide(my_slides[current_slide_number])
