# refactor01_shot_caller.gd

extends Node

##################################################
var my_name: String = "refactor01_shot_caller.gd"
func print_to_console(the_string: String):
	print(str(my_name, " says: ", the_string))
##################################################
	
enum GameMode {EXPLORE, RACE}

var music_player: AudioStreamPlayer
var current_music: AudioStream

var current_scene: Node2D = null
var current_menu: Node2D = null

@export var start_at_scene_number: int = 0

'''
the three types of tier-2 scenes: explore, race, menu, and cutscene
only one of these will be active at a time
'''
var explore_scenes = [
	preload("res://Refactor01/ExploreScenes/refactor01_explore_level.tscn")
]

var cutscenes = [
	preload("res://Refactor01/Cutscenes/refactor01_start_screen.tscn"),
	preload("res://Refactor01/Cutscenes/refactor01_cutscene01.tscn")
]

var race_scenes = [
	preload("res://Refactor01/RaceScenes/refactor01_race_scene_01.tscn"),
	preload("res://Refactor01/RaceScenes/refactor01_race_scene_02.tscn")
]

'''
menu scenes
'''

var menu_scenes = [
	
]

var hud_canvas: CanvasLayer
var hud_explore_mode_panel: Panel
var hud_race_mode_panel: Panel
var hud_cutscene_mode_panel: Panel
var hud_cutscene_dialog_panel: Panel
var hud_cutscene_slide: Sprite2D
var quest_menu_panel: Panel

func _ready():
	
	print_to_console("The game is starting")
	
	# set up the canvas
	hud_canvas = get_node("CanvasLayer")
	hud_explore_mode_panel = hud_canvas.get_node("ExploreModePanel")
	hud_race_mode_panel = hud_canvas.get_node("RaceModePanel")
	hud_cutscene_mode_panel = hud_canvas.get_node("CutsceneModePanel")
	hud_cutscene_dialog_panel = hud_cutscene_mode_panel.get_node("cutscene_dialog_panel")
	hud_cutscene_slide = hud_cutscene_mode_panel.get_node("cutscene_slide")
	quest_menu_panel = hud_canvas.get_node("QuestMenuPanel")
	
	hud_explore_mode_panel.visible = false
	hud_race_mode_panel.visible = false
	
	hud_cutscene_mode_panel.visible = false
	hud_cutscene_dialog_panel.visible = false
	
	quest_menu_panel.visible = false
	
	current_scene = null
	current_menu = null
	
	var the_bg = load("res://Slides/blank.png")
	set_cutscene_slide(the_bg)

	switch_to_cutscene(0)



func _process(delta):
	pass
	
####### Scene switching functions ###############
	
func switch_to_explore_scene(the_scene_number: int):
	var next_scene = explore_scenes[the_scene_number].instantiate()
	if current_scene != null:
		current_scene.queue_free()
	print_to_console(str("switching to scene: ", next_scene.name))
	add_child(next_scene)
	current_scene = next_scene
	
func switch_to_race_scene(the_scene_number: int):
	var next_scene = race_scenes[the_scene_number].instantiate()
	if current_scene != null:
		current_scene.queue_free()
	print_to_console(str("switching to scene: ", next_scene.name))
	add_child(next_scene)
	current_scene = next_scene
	
func switch_to_cutscene(the_scene_number: int):
	var next_scene = cutscenes[the_scene_number].instantiate()
	if current_scene != null:
		current_scene.queue_free()
	print_to_console(str("switching to scene: ", next_scene.name))
	add_child(next_scene)
	current_scene = next_scene
	
	
func switch_to_menu(the_menu_number: int):
	var next_menu = menu_scenes[the_menu_number].instantiate()
	if current_menu != null:
		current_menu.queue_free()
	print_to_console(str("displaying menu: ", next_menu.name))
	add_child(next_menu)
	current_menu = next_menu
	

######### HUD functions ##########
	
func set_explore_hud_panel_visible(the_bool: bool):
	hud_explore_mode_panel.visible = the_bool
	
func set_race_hud_panel_visible(the_bool: bool):
	hud_race_mode_panel.visible = the_bool
	
func set_cutscene_hud_panel_visible(the_bool: bool):
	hud_cutscene_mode_panel.visible = the_bool
	
func set_cutscene_dialog_panel_visible(the_bool: bool):
	hud_cutscene_dialog_panel.visible = the_bool
	
func set_cutscene_prompt_text(the_string: String):
	var prompt_text = hud_cutscene_mode_panel.get_node("cutscene_prompt_text")
	prompt_text.set_text(the_string)
	
func set_cutscene_dialog_text(the_string: String):
	var dialog_text = hud_cutscene_dialog_panel.get_node("cutscene_dialog_text")
	dialog_text.set_text(the_string)
	
func set_cutscene_slide(the_texture: Texture):
	hud_cutscene_slide.set_texture(the_texture)

	

		
	
	

