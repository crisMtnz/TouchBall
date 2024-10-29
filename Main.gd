extends Node2D

var rng = RandomNumberGenerator.new()

var speed_incremental = 5
var accumulated_incremental = 400

var obs1 = preload("res://obstacle_1.tscn")
var obs2 = preload("res://obstacle_2.tscn")
var score = 0

var stop = true
var dead = false

var previousObstaclePosition = Vector2(0,0)

func _ready():
	global.loadData()
	$DEBUG.text = global.debug_text
	
func _process(delta):
	
	if !stop:
		accumulated_incremental += speed_incremental*delta
		$ball.updateSpeed(speed_incremental*delta)
		$ball.setParticleSpeed(accumulated_incremental)
	
	
func _on_touch_screen_button_pressed():
	global.playSound("touch")
	#start for the first time
	if stop:
		stop = false
		$Label.text = "0"
		if global.gameMode == 1:
			$Timers/SpawnTimer.start()
		elif global.gameMode == 2:
			$Timers/SpawnTimerWide.wait_time = 115/accumulated_incremental
			$Timers/SpawnTimerWide.start()
		$ball.start()
	#restart
	elif dead:
		get_tree().reload_current_scene()
	#normal move
	else:
		$ball.changeDirections()
		

func _on_spawn_timer_timeout():
	var o = obs1.instantiate()
	o.setPosition(Vector2(rng.randf_range(250,750),-100))
	o.updateSpeed(accumulated_incremental)
	o.score.connect(_on_score)
	o.death.connect(_on_death)
	$Obstacles.add_child(o)


func _on_spawn_timer_wide_timeout():
	var o = obs2.instantiate()
	var pos = Vector2(0,0)
	if previousObstaclePosition == Vector2(0,0):
		pos = Vector2(rng.randf_range(250,750),-100)
	else:
		var diff = 0
		if previousObstaclePosition.x > 700:
			diff = rng.randf_range(-50,-20)
		elif previousObstaclePosition.x < 300:
			diff = rng.randf_range(20,50)
		else:
			if rng.randf() < 0.5:
				diff = rng.randf_range(-50,-20)
			else:
				diff = rng.randf_range(20,50)
		
		pos = Vector2(previousObstaclePosition.x + diff ,-100)
	o.setPosition(pos)
	previousObstaclePosition = pos

	o.updateSpeed(accumulated_incremental)
	o.score.connect(_on_score)
	o.death.connect(_on_death)
	$Obstacles.add_child(o)

	$Timers/SpawnTimerWide.wait_time = 115/accumulated_incremental -0.01
	$Timers/SpawnTimerWide.start()

func _on_score():
	if !dead:
		global.playSound("success")
		score += 1
		$Label.text = str(score)

func _on_death():
	if !dead:
		$ColorRect3.visible = true
		global.playSound("failure")
		
		if score > global.highScores[global.gameMode-1]:
			global.highScores[global.gameMode-1] = score
				
		global.saveData()
		$DEBUG.text = global.debug_text
		$Label.text = ("GAME OVER \n" +
						"SCORE: " + str(score) + "\n" +
						global.getData() + "\n" +
						"CLICK TO RESTART")
		dead = true
	
