extends Area2D

const SPEED = -150
const TYPEoFaREA = "rocket"
func _ready():
	pass

func _physics_process(delta):
	var velocity = Vector2.ZERO
	velocity.y = SPEED
	position+=velocity*delta

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	if area.get_groups()[0] != get_groups()[0] && area.get_groups()[0] != "helpful":
		queue_free()

