extends Node2D

onready var anim = $AnimationPlayer

func _ready():
	anim.playback_speed = .8
