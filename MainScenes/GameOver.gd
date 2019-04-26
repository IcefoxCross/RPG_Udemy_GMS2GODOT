extends Node

func _ready():
	$BGM.stream = load("res://Audio/BGM/a_graveyard_music.ogg")
	$BGM.play()

func _input(event):
	if event.is_action_pressed("action"):
		get_tree().quit()