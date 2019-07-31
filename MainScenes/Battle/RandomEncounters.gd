extends Node

"""
Random Encounters
	Sets which Enemy will the Player fight in the current map, with a set level
"""

export (bool) var on = true
export (String) var enemy
export (int) var level = 1

func _ready():
	pass