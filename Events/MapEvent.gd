extends Node

class_name MapEvent

signal finished()

var local_map
var player

func _ready():
	add_to_group("map_event")
	player = get_tree().get_nodes_in_group("player")[0]

func initialize(map):
	local_map = map

func interact():
	emit_signal("finished")