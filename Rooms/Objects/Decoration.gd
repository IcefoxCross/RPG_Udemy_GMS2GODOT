extends Node2D

"""
Decoration
	Basic Decoration Node from which other Decorations inherit, its Depth is set by its Y position on the map.
"""

func _ready():
	z_index = position.y