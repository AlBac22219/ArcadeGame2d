extends CharacterBody2D

@export var bolt: PackedScene
@export var rocket: PackedScene
@export var torped: PackedScene

signal hit
signal die
signal takeBonus

var hp = 3
var screen_size
var TimeoutBetweenShoot = true
var isShooting = true
var isStart = false
var isNotInvincible = true
var timeForTimer = 1.3
@onready var animation_player = $AnimationPlayer
const SPEED = 100.0
const CountOfAmmo = 5
enum AmmoType {Bolt, Rocket, Torpedo}
var NowAmmoType = AmmoType.Bolt

func _ready():
	hide()
	screen_size = get_viewport_rect().size
	screen_size.x = 450
	

func start(pos):
	$Shield.hide()
	position = pos
	hp = 3
	animation_player.play("Idle")
	$Sprite2D2.hide()
	$Sprite2D.show()
	show()
	$EngineAnim.show()
	$Area2D/CollisionShape2D.set_deferred("disabled",false)
	$CollisionPolygon2D.set_deferred("disabled",false)
	$Engine.play("idle")
	$ShieldPlayer.stop()
	NowAmmoType = AmmoType.Bolt
	
func _process(delta):
	var input_vector= Vector2.ZERO
	input_vector.x = (Input.get_action_strength("RightMove") - Input.get_action_strength("LeftMove"))*SPEED
	if input_vector != Vector2.ZERO :
		velocity = input_vector
	else:
		velocity = Vector2.ZERO
	position += velocity * delta
	position.x = clamp(position.x, 30, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	if Input.is_action_pressed("Fire") && TimeoutBetweenShoot && isStart:
		shoot()
	elif  !isShooting:
		animation_player.play("Idle")	
	move_and_collide(velocity * delta)


func _on_time_between_shoot_timeout():
	TimeoutBetweenShoot = true


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Shooting":
		isShooting = false
	elif anim_name == "death":
		hide()
		
func shoot():
	animation_player.play("Shooting")
	$TimeBetweenShoot.start(timeForTimer)
	TimeoutBetweenShoot = false
	isShooting = true
	match NowAmmoType:
		AmmoType.Bolt:
			var newBolt = bolt.instantiate()
			owner.add_child(newBolt)
			newBolt.transform = $ShootPosition.global_transform
			$boltShoot.play()
		AmmoType.Rocket:
			var newRocket = rocket.instantiate()
			owner.add_child(newRocket)
			newRocket.transform = $ShootPosition.global_transform
			$rocketShoot.play()
		AmmoType.Torpedo:
			var newTorped = torped.instantiate()
			owner.add_child(newTorped)
			newTorped.transform = $ShootPosition.global_transform
			$torpedoShoot.play()
	$TimerForSecondshoot.start(0.3)

func _on_area_2d_area_entered(area):
	match area.get_groups()[0]:
		"enemies":
			if isNotInvincible:
				if hp>0:
					isNotInvincible = false
					$invincibleTimer.start(2)
					hp-=1
					$Shield.show()
					$ShieldPlayer.play("Idle")
					emit_signal("hit")
				else:
					emit_signal("die")
					$Sprite2D.hide()
					$Sprite2D2.show()
					$EngineAnim.hide()
					animation_player.play("death")
					$Area2D/CollisionShape2D.set_deferred("disabled", true)
					$CollisionPolygon2D.set_deferred("disabled", true)
					$Shield.hide()
					$ShieldPlayer.stop()
					DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
		"helpful":
			match area.typeOfBuff:
				"heal":
					hp+=1
					emit_signal("hit")
				"weapon":
					match NowAmmoType:
						AmmoType.Bolt:
							NowAmmoType = AmmoType.Rocket
						AmmoType.Rocket:
							NowAmmoType = AmmoType.Torpedo
				"immortal":
					isNotInvincible = false
					$invincibleTimer.start(10)
					$Shield.show()
					$ShieldPlayer.play("Idle")
			emit_signal("takeBonus")



func _on_invincible_timer_timeout():
	isNotInvincible = true
	$Shield.hide()
	$ShieldPlayer.stop()


func _on_timer_for_secondshoot_timeout():
	match NowAmmoType:
		AmmoType.Bolt:
			var newBolt = bolt.instantiate()
			owner.add_child(newBolt)
			newBolt.transform = $ShootPosition2.global_transform
			$boltShoot.play()
		AmmoType.Rocket:
			var newRocket = rocket.instantiate()
			owner.add_child(newRocket)
			newRocket.transform = $ShootPosition2.global_transform
			$rocketShoot.play()
		AmmoType.Torpedo:
			var newTorped = torped.instantiate()
			owner.add_child(newTorped)
			newTorped.transform = $ShootPosition2.global_transform
			$torpedoShoot.play()
