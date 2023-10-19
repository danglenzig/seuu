extends Node2D

var impact_effect
var accelerate_effect
var splode_effect

# Called when the node enters the scene tree for the first time.
func _ready():
	impact_effect = get_node("SparkVFX")
	accelerate_effect = get_node("AccelerateVFX")
	splode_effect = get_node("SplodeVFX")
	
	impact_effect.visible = false
	accelerate_effect.visible = false
	splode_effect.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func play_impact_effect(impact_type):
	impact_effect.visible = true
	impact_effect.play()
	
	
func play_accelerate_effect(the_bool):
	accelerate_effect.visible = the_bool
	accelerate_effect.play()
	
	
func play_splode_effect():
	splode_effect.visible = true
	splode_effect.play()
	
