extends "res://MainScenes/Battle/Units/BattleUnit.gd"

onready var anim = $AnimationPlayer
onready var sprite = $Sprite

func _ready():
	._ready()
	anim.playback_speed = 1
	sprite.flip_h = true
