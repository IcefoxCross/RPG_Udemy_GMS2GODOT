extends KinematicBody2D

"""
Interactable
	Basic Interactable Node that performs an action when the player interacts with it.
"""

var other

func _ready():
	z_index = position.y

func interact(body):
	other = body