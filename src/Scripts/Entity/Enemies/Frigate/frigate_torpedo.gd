extends Area2D

var hp = 0
var SPEED = 170
const TYPEoFaREA = "enemie"

func _physics_process(delta):
	var velocity = Vector2.ZERO
	velocity.y = SPEED
	position+=velocity*delta
	

func _on_area_entered(area):
	if area.get_groups()[0] == "player":
		queue_free()

	
func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
