extends CharacterBody2D


var ACCELERATION = 500
var speed = 0
var direction = 1

var stop = true

func start():
	stop = false
	$CPUParticles2D.emitting = true

func changeDirections():
	direction *= -1
	
#called from main every frame
func updateSpeed(incremental):
	ACCELERATION += incremental
	
#called from main every frame
func setParticleSpeed(s):
	$CPUParticles2D.initial_velocity_max = s
	$CPUParticles2D.initial_velocity_min = s

#debug
func getData():
	return (
			"Position_x: " + str(round(position.x)) + "\n" + 
			"speed: " + str(round(speed)) + "\n" + 
			"direction: " + str(direction)
			)

func _physics_process(delta):
	if !stop:
		#doubles the speed if decelerating
		if direction * speed < 0:
			speed += ACCELERATION*direction*delta
		speed += ACCELERATION*direction*delta
		if (position.x >= 654 && speed > 0) || (position.x <= 66 && speed < 0):
			speed = 0
		
		velocity = Vector2(speed,0.0)
		
		move_and_slide()
