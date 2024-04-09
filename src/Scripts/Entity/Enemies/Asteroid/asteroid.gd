extends Area2D

signal enemie_die(score)

var dieFromPlayer = false
var score = 2
var hp = 2
var SPEED = 175
var rotation_speed = 1.5
const TYPEoFaREA = "enemie"
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	SPEED = randi()%220+40
	rotation_speed = randf_range(-2,2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	velocity.y = SPEED
	position+=velocity*delta
	rotation+=rotation_speed*delta
	$Engine.rotation-=rotation_speed*delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	match area.TYPEoFaREA:
		"player":
			hp=-1
			$AnimationPlayer.play("death")
			$CollisionShape2D.set_deferred("disabled", true)
			$Engine.hide()
			$death.play()
			SPEED = 0
			dieFromPlayer = true
		"bolt":
			hp-=1
		"rocket":
			hp-=2
		"torpedo":
			hp-=3
	if hp>0:
		pass
	else:
		$AnimationPlayer.play("death")
		$CollisionShape2D.set_deferred("disabled", true)
		$Engine.hide()
		$death.play()
		if !dieFromPlayer:
			emit_signal("enemie_die")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "deth":
		hide()
