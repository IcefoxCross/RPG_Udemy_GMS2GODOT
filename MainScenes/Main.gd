extends Node

onready var player = $Common/Elizabeth
onready var gui = $Common/GUI
onready var bgm = $Common/BGM
onready var sfx = $Common/SFX

onready var camera = player.camera

const FADE = preload("res://UI/FadeTransition.tscn")
const BATTLE = preload("res://UI/BattleTransition.tscn")
const OPTIONS = preload("res://UI/Menus/OptionsMenu.tscn")
const MSG = preload("res://UI/Message.tscn")

var current_room
var current_bgm

var rand_e

func _ready():
	get_tree().paused = false
	if GData.loaded:
		GData.load_game("game01.save")
		GData.loaded = false
	var new_room = load(GData.last_room["room"]).instance()
	$Room.add_child(new_room)
	new_room.init(player)
	current_room = new_room
	# Set music
	if current_room.bgm != "none":
		current_bgm = current_room.bgm
		bgm.volume_db = -10
		bgm.stream = load(current_room.bgm)
		bgm.play()
	else:
		bgm.fade_out()
	rand_e = current_room.rand_e
	# Set Player
	player.start(Vector2(GData.last_room["x"],GData.last_room["y"]),GData.last_room["dir"])
	current_room.connect("change_room", self, "_change_room")
	player.connect("encounter", self, "encounter")
	player.connect("menu_call", self, "call_menu")
	var fade = FADE.instance()
	get_tree().current_scene.add_child(fade)
	fade.fade(0)
	player.stop()
	yield(fade, "fade_done")
	player.resume()
	GData.pause_enabled = true
	for event in current_room.events:
		event.interact()
		yield(event, "finished")

func encounter():
	if player == null or rand_e == null:
		return
	if rand_e.on and not get_tree().current_scene.has_node("/BattleTransition"):
		GData.b_enemy = rand_e.enemy
		GData.b_level = rand_e.level
		player.state = "wait_state"
		GData.last_room["room"] = current_room.filename
		GData.last_room["x"] = player.position.x
		GData.last_room["y"] = player.position.y
		GData.last_room["dir"] = player.spritedir
		var fade = BATTLE.instance()
		get_tree().current_scene.add_child(fade)
		fade.fade(1)
		bgm.fade_out()
		yield(fade, "fade_done")
		#GData.switch_scene("res://MainScenes/Battle/Battle.tscn")
		get_tree().change_scene("res://MainScenes/Battle/Battle.tscn")

func call_menu():
	if not gui.find_node("OptionsMenu"):
		var options = OPTIONS.instance()
		gui.add_child(options)

func create_message(x, y, text, timed = true):
	var msg = MSG.instance()
	gui.add_child(msg)
	msg.initialize(x, y, text, timed)
	return msg

func create_message_centered(text, timed = true):
	var msg = MSG.instance()
	gui.add_child(msg)
	msg.initialize_centered(text, timed)
	return msg

func _change_room(target_room):
	call_deferred("_change_room_deferred", target_room)

func _change_room_deferred(target_room):
	var new_room = load(target_room).instance()
	var tofrom = "%s%s" % [new_room.name, current_room.name]
	var fade = FADE.instance()
	get_tree().current_scene.add_child(fade)
	player.stop()
	fade.fade(1)
	yield(fade, "fade_done")
	current_room.queue_free()
	$Room.add_child(new_room)
	new_room.init(player)
	current_room = new_room
	rand_e = current_room.rand_e
	var pos = current_room.find_node(tofrom).spawn_point
	player.start(pos,player.spritedir)
	fade.fade(0)
	if current_room.bgm != "none":
		if current_bgm != current_room.bgm:
			bgm.fade_out()
			yield(bgm,"faded")
			bgm.volume_db = -10
			current_bgm = current_room.bgm
			bgm.stream = load(current_room.bgm)
			bgm.play()
	else:
		current_bgm = "none"
		bgm.fade_out()
	current_room.connect("change_room", self, "_change_room")