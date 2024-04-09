extends Area2D

const TYPEoFaREA = "buff"
const SPEED = 80

var typeOfBuff = null
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	var velocity = Vector2.ZERO
	velocity.y = SPEED
	position+=velocity*delta

func create_buff(hpOfPlayer, playerTypeAmmo):
	print(playerTypeAmmo)
	var typeOfBuff = randi()%4
	match typeOfBuff:
		0:
			if hpOfPlayer<3:
				hpBuff()
		1:
			if playerTypeAmmo<2:
				ammoBuff(playerTypeAmmo)
		2:
			immortalBuff()
		3:
			hide()

func hpBuff():
	$Sprite2D.set_texture(load("res://Assets/Textures/Buff/HPBuff.png"))
	typeOfBuff = "heal"

func ammoBuff(playerTypeAmmo):
	match playerTypeAmmo:
		0:
			$Sprite2D.set_texture(load("res://Assets/Textures/Buff/RocketBuff.png"))
		1:
			$Sprite2D.set_texture(load("res://Assets/Textures/Buff/TorpedoBuff.png"))
	typeOfBuff = "weapon"

func immortalBuff():
	$Sprite2D.set_texture(load("res://Assets/Textures/Buff/ImmortalBuff.png"))
	typeOfBuff = "immortal"


func _on_area_entered(area):
	if area.TYPEoFaREA == "player":
		$AudioStreamPlayer.play()
		queue_free()

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
