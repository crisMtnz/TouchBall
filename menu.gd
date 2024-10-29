extends Node2D


func _on_button_1_pressed():
	global.gameMode = 1
	get_tree().change_scene_to_file("res://main.tscn")

func _on_button_2_pressed():
	global.gameMode = 2
	get_tree().change_scene_to_file("res://main.tscn")


