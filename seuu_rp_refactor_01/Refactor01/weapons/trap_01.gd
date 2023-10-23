extends Area2D

@export var splode_vfx: AnimatedSprite2D
@export var die_timer: Timer
@export var trap_lifetime: float
@export var splode_on_timeout: bool =  false

# Called when the node enters the scene tree for the first time.
func _ready():
	splode_vfx.visible = false
	die_timer.set_wait_time(trap_lifetime)
	die_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func splode():
	var my_sprite = get_node("Sprite2D")
	my_sprite.visible = false
	splode_vfx.visible = true
	splode_vfx.play()
	



func _on_splode_vfx_animation_finished():
	self.queue_free()


func _on_die_timer_timeout():
	if splode_on_timeout:
		splode()
	else:
		self.queue_free()
