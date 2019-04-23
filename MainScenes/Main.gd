extends Node

onready var player = $Common/Elizabeth
onready var gui = $Common/GUI
onready var randenc = $Common/RandomEncounters

onready var camera = player.camera

const FADE = preload("res://UI/FadeTransition.tscn")
const BATTLE = preload("res://UI/BattleTransition.tscn")
const OPTIONS = preload("res://UI/Menus/OptionsMenu.tscn")
const MSG = preload("res://UI/Message.tscn")

var current_room

func _ready():
	var new_room = load(GData.last_room["room"]).instance()
	$Room.add_child(new_room)
	new_room.init(player)
	current_room = new_room
	player.start(Vector2(GData.last_room["x"],GData.last_room["y"]),GData.last_room["dir"])
	current_room.connect("change_room", self, "_change_room")
	player.connect("encounter", self, "encounter")
	player.connect("menu_call", self, "call_menu")
	var fade = FADE.instance()
	get_tree().current_scene.add_child(fade)
	fade.fade(0)
	GData.pause_enabled = true
	yield(fade, "fade_done")
	var events = current_room.find_node("Events")
	if events and events.get_child_count() > 0:
		for event in events.get_children():
			event.interact()
			yield(event, "finished")
			#queue_free()

func encounter():
	if player == null or randenc == null:
		return
	if randenc.on and not get_tree().current_scene.has_node("/BattleTransition"):
		player.state = "wait_state"
		GData.last_room["room"] = current_room.filename
		GData.last_room["x"] = player.position.x
		GData.last_room["y"] = player.position.y
		GData.last_room["dir"] = player.spritedir
		var fade = BATTLE.instance()
		get_tree().current_scene.add_child(fade)
		fade.fade(1)
		yield(fade, "fade_done")
		#GData.switch_scene("res://MainScenes/Battle/Battle.tscn")
		get_tree().change_scene("res://MainScenes/Battle/Battle.tscn")

func call_menu():
	if not gui.find_node("OptionsMenu"):
		var options = OPTIONS.instance()
		gui.add_child(options)

func create_message(x, y, text):
	var msg = MSG.instance()
	gui.add_child(msg)
	msg.initialize(x, y, text)
	return msg

func create_message_centered(text):
	var msg = MSG.instance()
	msg.initialize_centered(text)
	gui.add_child(msg)
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
	var pos = current_room.find_node(tofrom).spawn_point
	player.start(pos)
	fade.fade(0)
	current_room.connect("change_room", self, "_change_room")