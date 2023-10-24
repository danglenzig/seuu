extends Panel

var my_anim
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	my_anim = get_node("AnimatedSprite2D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_wipe():
	visible = true
	my_anim.play()
	
func hide_me():
	visible = false
	


func _on_animated_sprite_2d_animation_finished():
	hide_me()
