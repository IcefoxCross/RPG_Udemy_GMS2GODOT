extends Node2D

const BATTLE = preload("res://UI/BattleTransition.tscn")
const FADE = preload("res://UI/FadeTransition.tscn")

onready var camera = $BattleCamera
onready var enemy = $Units/EnemyUnit

var play

func _ready():
	play = true
	Game.room_height = 180
	Game.room_width = 640
	var fade = BATTLE.instance()
	get_tree().current_scene.add_child(fade)
	fade.fade(0)
	camera.start()
	enemy.connect("battle_won", self, "end_battle")

func end_battle():
	play = false
	camera.state = "idle_state"
	var fade = FADE.instance()
	get_tree().current_scene.add_child(fade)
	fade.fade(1)
	yield(fade, "fade_done")
	#gdata.load_scene()
	get_tree().change_scene("res://MainScenes/Main.tscn")