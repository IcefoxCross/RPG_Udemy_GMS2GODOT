extends Node

onready var player = $Common/Elizabeth
onready var gui = $Common/GUI
onready var randenc = $Common/RandomEncounters

const FADE = preload("res://UI/FadeTransition.tscn")
const BATTLE = preload("res://UI/BattleTransition.tscn")

var current_room

func _ready():
	var new_room = load(gdata.last_room["room"]).instance()
	$Room.add_child(new_room)
	new_room.init(player)
	current_room = new_room
	player.start(Vector2(gdata.last_room["x"],gdata.last_room["y"]),gdata.last_room["dir"])
	current_room.connect("change_room", self, "_change_room")
	player.connect("encounter", self, "encounter")
	var fade = FADE.instance()
	get_tree().current_scene.add_child(fade)
	fade.fade(0)
	yield(fade, "fade_done")

func encounter():
	if player == null or randenc == null:
		return
	if randenc.on and not get_tree().current_scene.has_node("/BattleTransition"):
		player.state = "wait_state"
		gdata.last_room["room"] = current_room.filename
		gdata.last_room["x"] = player.position.x
		gdata.last_room["y"] = player.position.y
		gdata.last_room["dir"] = player.spritedir
		var fade = BATTLE.instance()
		get_tree().current_scene.add_child(fade)
		fade.fade(1)
		yield(fade, "fade_done")
		#gdata.switch_scene("res://MainScenes/Battle/Battle.tscn")
		get_tree().change_scene("res://MainScenes/Battle/Battle.tscn")

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