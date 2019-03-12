extends Area2D

export (String, FILE) var target_room

onready var pos = $Position2D

var spawn_point

signal transition_room

func _ready():
	spawn_point = pos.global_position

func _on_Door_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("transition_room", target_room)
