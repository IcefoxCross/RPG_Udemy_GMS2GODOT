extends Node2D

"""
Shield
	Effect Node to represent when the Unit if defending against attacks.
	Only for visual representation, it does not affect the gameplay functionally.
"""

onready var sprite = $Sprite

var start_y = position.y

func _ready():
	pass

func _process(delta):
	var input = OS.get_ticks_msec() / 8
	position.y =  start_y + cos(input/8 + PI)*2 - 24