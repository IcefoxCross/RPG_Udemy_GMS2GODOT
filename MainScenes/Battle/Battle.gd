extends Node2D

const BATTLE = preload("res://UI/BattleTransition.tscn")
const FADE = preload("res://UI/FadeTransition.tscn")
const MSG = preload("res://UI/Message.tscn")

onready var camera = $BattleCamera
onready var enemy = $Units/EnemyUnit
onready var player = $Units/PlayerUnit

var play = true

func _ready():
	play = true
	Game.room_height = 180
	Game.room_width = 640
	var fade = BATTLE.instance()
	get_tree().current_scene.add_child(fade)
	fade.fade(0)
	camera.start()
	enemy.connect("battle_won", self, "end_battle")

func _process(delta):
	if find_node("PlayerUnit") and find_node("EnemyUnit"):
		if player.state == "wait_state" and enemy.state == "wait_state":
			player.state = "idle_state"
			enemy.state = "idle_state"
			play = true

func end_battle():
	play = false
	camera.state = "idle_state"
	var fade = FADE.instance()
	get_tree().current_scene.add_child(fade)
	fade.fade(1)
	yield(fade, "fade_done")
	#GData.load_scene()
	get_tree().change_scene("res://MainScenes/Main.tscn")

func create_message(x, y, text):
	var msg = MSG.instance()
	$CanvasLayer.add_child(msg)
	msg.initialize(x, y, text)
	return msg

func create_message_centered(text):
	var msg = MSG.instance()
	msg.initialize_centered(text)
	$CanvasLayer.add_child(msg)
	return msg