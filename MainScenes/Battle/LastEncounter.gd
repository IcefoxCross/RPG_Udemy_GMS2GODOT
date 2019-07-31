extends Node2D

"""
Last Encounter Node
	Keeps track of the last position where a battle started for future control
"""

var distance

func _ready():
	distance = 0
