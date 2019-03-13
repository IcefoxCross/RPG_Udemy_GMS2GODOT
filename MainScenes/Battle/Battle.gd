extends Node2D

const BATTLE = preload("res://UI/BattleTransition.tscn")

onready var camera = $BattleCamera

func _ready():
	Game.room_height = 180
	Game.room_width = 640
	var fade = BATTLE.instance()
	get_tree().current_scene.add_child(fade)
	fade.fade(0)
	camera.start()