extends Node2D

onready var anim = $AnimationPlayer
onready var sprite = $Sprite

func _ready():
	anim.playback_speed = 1
	sprite.flip_h = true
