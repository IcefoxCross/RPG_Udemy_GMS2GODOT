extends "res://UI/Speaker.gd"

"""
Character
	Basic entity that can be interacted with, being able to move
"""

onready var sprite = $Sprite
onready var anim = $AnimationPlayer

export (float) var move_speed = 100.0

var start = Vector2()
var target = null
var spritedir = "down"

func _ready():
	start = position

func _physics_process(delta):
	z_index = max(0,position.y)

func anim_switch(animation):
	var new_anim = str(animation,spritedir)
	if anim.has_animation(new_anim):
		if anim.current_animation != new_anim:
			anim.play(new_anim)

func spritedir_set():
	if target == null: return
	var dir = (target - position).normalized().round()
	if dir.x == 1:	spritedir = "right"
	if dir.x == -1:	spritedir = "left"
	if dir.y == 1:	spritedir = "down"
	if dir.y == -1:	spritedir = "up"
	return dir