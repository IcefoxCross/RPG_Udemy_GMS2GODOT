extends Node

"""
Map Event Node
	The root Event Node, all other action event inherit from this. Every child must represent a single action to perform,
that must be executed when called by the function interact(). It must finish the execution by emitting the signal finished.
"""

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