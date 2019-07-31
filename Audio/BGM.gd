extends AudioStreamPlayer

"""
BGM - Background Music Node
An audio node recommended for audio files that will play and loop as background music for the game.

Script Variables
---
fade_duration: How long will the fade out effect last
fade_type: Type of fade out from an Enum list given by the engine

Functions
---
fade_out(): Decreases the volume of the current playing track until it reaches an inaudible value.
"""

signal faded

onready var tween = $Tween

export (float) var fade_duration = 0.5
export (int) var fade_type = 1 #TRANS_SINE


func fade_out():
	tween.interpolate_property(self, "volume_db", volume_db, -80, fade_duration, fade_type, Tween.EASE_IN, 0)
	tween.start()
	yield(tween,"tween_completed")
	emit_signal("faded")

func _on_Tween_tween_completed(object, key):
	stop()
