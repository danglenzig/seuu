# shot_caller.gd

extends Node

#class_name ShotCaller

var music_player: AudioStreamPlayer
var current_music: AudioStream

@export var start_at_scene_number: int = 0
var current_game_scene: int


var game_scenes = [
	preload("res://Scenes/start_menu.tscn"),
	preload("res://Scenes/intro_cutscene.tscn"),
	preload("res://Scenes/gs_explore_mode.tscn"),
]

var race_scenes = [
	preload("res://Scenes/gs_race_01.tscn"),
	preload("res://Scenes/gs_race_02.tscn")
]


var player_progres: Resource

# Called when the node enters the scene tree for the first time.
func _ready():
	player_progres = load("res://InfoFiles/player_progress.gd")
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.set_volume_db(-15.0)
	switch_to_game_scene(start_at_scene_number)
	current_game_scene = start_at_scene_number

func start_race(race_number):
	var next_race = race_scenes[race_number].instantiate()
	add_child(next_race)

func switch_to_game_scene(gs_index):
	var next_scene = game_scenes[gs_index].instantiate()
	add_child(next_scene)
#	current_game_scene = gs_index

