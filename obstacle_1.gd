extends Node2D

var speed = 0
signal score
signal death

func setPosition(vectorPosition):
	position = vectorPosition

func updateSpeed(incremental):
	speed += incremental

func _process(delta):
	position.y += speed*delta
	if position.y > 1700 :
		queue_free()


func _on_death_body_entered(body):
	if body.name == "ball":
		emit_signal("death")


func _on_score_body_entered(body):
	if body.name == "ball":
		emit_signal("score")
