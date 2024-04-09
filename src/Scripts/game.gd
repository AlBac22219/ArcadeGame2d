extends Node

var PlayerSpeed = 0

@export var asteroid: PackedScene
@export var fighter: PackedScene
@export var frigate: PackedScene
@export var scout: PackedScene
@export var buff: PackedScene
@onready var audioPlayer = $AudioStreamPlayer
enum eventStates {lightFleet, asteroids, middleFleet, heavyFleet}
var eventState
var mob = null

func _ready():
	startMusic()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Background.position[1] <= 1420:
		$Background.position[1] += PlayerSpeed
	else:
		$Background.position[1] = -700
	if mob!=null:
		mob.enemie_die.connect(enemie_die.bind(mob))


func _on_player_hit():
	$HUD/HP/HPCount.text = str($Player.hp+1)


func startMusic():
	randomize()
	var numberOfMusic = randi()%8 + 1
	var nameOfMusic = "res://Assets/Sounds/Background/Sci-Fi " + str(numberOfMusic) + ".wav"
	audioPlayer.stream = load(nameOfMusic)
	audioPlayer.play()

func _on_audio_stream_player_finished():
	startMusic()


func _on_hud_start_game():
	$Player.show()
	$Player.isStart = true
	$Player.start($PlayerPosition.position)
	$HUD/HP/HPCount.text = str($Player.hp+1)
	PlayerSpeed = 0.4
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("helpful", "queue_free")
	$StartTimer.start(3)


func _on_mob_timer_timeout():
	match eventState:
		eventStates.lightFleet:
			mob = scout.instantiate()
			mobSpawn(mob)
		eventStates.middleFleet:
			var change = randi()%4
			if change<3:
				mob = fighter.instantiate()
				mobSpawn(mob)
			else :
				mob = scout.instantiate()
				mobSpawn(mob)
		eventStates.heavyFleet:
			var change = randi()%8
			if change>5:
				mob = frigate.instantiate()
				mobSpawn(mob)
			else :
				mob = fighter.instantiate()
				mobSpawn(mob)
		eventStates.asteroids:
			mob = asteroid.instantiate()
			mobSpawn(mob)
	$MobTimer.start(randf_range(0.1,0.7))

func mobSpawn(mob):
	var mobSpawnLocation = get_node("MobSpawn/MobSpawnPoint")
	mobSpawnLocation.progress_ratio = randi()
	mob.position = mobSpawnLocation.position
	add_child(mob)
	
func enemie_die(score):
	$HUD.enemyScore(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	$EventTimer.start()
	$BuffTimer.start()
	eventState = eventStates.asteroids


func _on_event_timer_timeout():
	var newEvent = randi()%4
	match newEvent:
		0:
			eventState = eventStates.lightFleet
		1:
			eventState = eventStates.middleFleet
		2:
			eventState = eventStates.heavyFleet
		3: 
			eventState = eventStates.asteroids
	var newTime = randf_range(40,120)
	$EventTimer.start(newTime)
	


func _on_player_die():
	$Player.hide()
	$Player.isStart = false
	$HUD.game_over()
	$HUD/HP/HPCount.text = "0"
	$EventTimer.stop()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$BuffTimer.stop()
	mob = null

func _on_buff_timer_timeout():
	var newBuffChange = randi()%18
	if newBuffChange <8:
		var buffSpawnLocation = get_node("MobSpawn/MobSpawnPoint")
		var newBuff = buff.instantiate()
		newBuff.create_buff($Player.hp,$Player.NowAmmoType)
		buffSpawnLocation.progress_ratio = randi()
		newBuff.position = buffSpawnLocation.position
		add_child(newBuff)
	$BuffTimer.start(15)


func _on_player_take_bonus():
	$HUD.takeBonus(100)
