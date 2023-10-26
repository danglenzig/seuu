extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_fire_tick(my_aggro: int): # this pops off when some "fire_check_interval" timer resets
	# roll a D20
	var fire_roll = (randi() % 20) + 1
	if fire_roll >= my_aggro:
		fire()
		
func fire():
	pass
	# do whatever
