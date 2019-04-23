extends KinematicBody2D

var other

func _ready():
	z_index = position.y

func interact(body):
	other = body