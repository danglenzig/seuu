extends Node2D

var upper_left_ui_text: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	upper_left_ui_text = get_node("CanvasLayer/lap_counter_text")
	upper_left_ui_text.set_text("Laps complete: 0")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_ai_car_01_did_a_lap(the_name, the_laps):
	upper_left_ui_text.set_text(str(the_name, " Laps complete: ", the_laps))
