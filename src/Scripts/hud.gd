extends CanvasLayer

signal start_game

@onready var GAMEOVER = load("res://Assets/Textures/MainGame/Game_Over.png")
@onready var GAMENAME = load("res://Assets/Textures/MainGame/Space_Battle.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	$HP.hide()
	$Score.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	$Title.hide()
	$Button.hide()
	$Score.show()
	$HP.show()
	$Score.text = "0"
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	emit_signal("start_game")

func game_over():
	$Title.texture = GAMEOVER
	$Title.show()
	$GameOverTimer.start(5)
	await $GameOverTimer.timeout
	$Title.texture = GAMENAME
	$Button.show()
	$Score.hide()
	$HP.hide()

func takeBonus(bonusScore):
	var score = int($Score.text)
	score+=bonusScore
	$Score.text = str(score)

func _on_score_timer_timeout():
	var score = int($Score.text)
	score+=5
	$Score.text = str(score)

func enemyScore(enemyScore):
	var score = int($Score.text)
	score+=enemyScore.score
	$Score.text = str(score)
