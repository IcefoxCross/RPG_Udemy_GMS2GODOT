extends Node2D

onready var sprite = $Sprite

signal finished

var target = null
var creator = null

func _ready():
	pass

func _process(delta):
	if not target or not creator:
		queue_free()
