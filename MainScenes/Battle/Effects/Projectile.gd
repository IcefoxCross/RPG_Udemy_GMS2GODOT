extends Node2D

"""
Projectile Spell
	A Parent Template node to set the basic information to use in a skill that involves a caster throwing something to a target.
	Other Projectile spells must inherit from this Node.
"""

onready var sprite = $Sprite
onready var sfx = $SFX

signal finished

var target = null
var creator = null

func _ready():
	pass

func _process(delta):
	if not target or not creator:
		queue_free()
