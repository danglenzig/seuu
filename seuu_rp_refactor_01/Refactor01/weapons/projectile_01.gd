extends RigidBody2D

##################################################
var my_name: String = "projectile_01.gd"
func print_to_console(the_string: String):
	print(str(my_name, " says: ", the_string))
##################################################

@export var projectile_lifetime: float = 1
@export var die_timer: Timer
@export var impact_vfx: AnimatedSprite2D
@export var my_sprite: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	die_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_die_timer_timeout():
	self.queue_free()

func splode():
	print_to_console("splode")
	my_sprite.visible = false
	impact_vfx.play()

func _on_projectile_trigger_body_entered(body):
	var helper_string = "street_collider"
	if helper_string in body.name:
		splode()
		


func _on_impact_vfx_animation_finished():
	self.queue_free()
