extends Node2D

export (String) var room_tilemap = "TileMap"
export(String, FILE, "*.ogg") var bgm = "none"

signal change_room

onready var events = $Events.get_children()
onready var rand_e = $RandomEncounters

var player
var cell_size
var room_size

func _ready():
	cell_size = $TileMap.cell_size
	room_size = find_node(room_tilemap).get_used_rect()
	for d in get_tree().get_nodes_in_group("door"):
		d.connect("transition_room", self, "_transition")

func init(_player):
	player = _player
	set_camera_limits()

func set_camera_limits():
	player.get_node("Camera2D").limit_left = (room_size.position.x) * cell_size.x
	player.get_node("Camera2D").limit_right = (room_size.end.x) * cell_size.x
	player.get_node("Camera2D").limit_top = (room_size.position.y) * cell_size.y
	player.get_node("Camera2D").limit_bottom = (room_size.end.y) * cell_size.y

func _transition(target_room):
	emit_signal("change_room", target_room)