extends "res://MainScenes/Battle/Units/BattleUnit.gd"

onready var anim = $AnimationPlayer

func _ready():
	._ready()
	anim.playback_speed = .8
