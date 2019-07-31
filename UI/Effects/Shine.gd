extends Node2D

"""
Shine
	Effect Node used on the Level Up Animation.
"""

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
