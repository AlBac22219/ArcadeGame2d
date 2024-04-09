extends Area2D

signal enemie_die(score)

var dieFromPlayer = false
var score = 12
@export var torpedo: PackedScene
var hp = 3
var SPEED = 100
const TYPEoFaREA = "enemie"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	velocity.y = SPEED
	position+=velocity*delta


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
	if hp==1:
		$ShieldPlayer.stop()
		$Shield.hide()
	elif hp>0:
		pass
	else:
		$ShieldPlayer.stop()
		$Shield.hide()
		$AnimationPlayer.play("death")
		$CollisionShape2D.set_deferred("disabled", true)
		$Engine.hide()
		$death.play()
		SPEED = 0
		if !dieFromPlayer:
			emit_signal("enemie_die")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "death":
		hide()


func _on_timer_between_shoot_timeout():
	var change = randi()%100
	if change<=25:
		var newTorped = torpedo.instantiate()
		add_child(newTorped)
		newTorped.transform = $ShootPosition.transform
	$TimerBetweenShoot.start(2)
