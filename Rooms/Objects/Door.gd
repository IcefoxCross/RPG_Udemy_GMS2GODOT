extends Area2D

"""
Door
	Node that transfers the player to a new map when the playable character collides with it.
"""

export (String, FILE) var target_room
export(String, FILE, "*.wav") var sound = "res://Audio/SFX/enter_next_area.wav"

onready var pos = $Position2D

var spawn_point

signal transition_room

func _ready():
	spawn_point = pos.global_position

func _on_Door_body_entered(body):
	if body.is_in_group("player"):
		get_tree().current_scene.sfx.sound(sound)
		emit_signal("transition_room", target_room)
