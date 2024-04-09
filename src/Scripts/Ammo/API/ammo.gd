extends Area2D

signal hit

const SPEED = -80

func _ready():
	pass

func _physics_process(delta):
	var velocity = Vector2.ZERO
	velocity.y = SPEED
	position+=velocity*delta
	


func _on_body_entered(body):
	hide()
	emit_signal("hit")



func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
