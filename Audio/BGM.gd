extends AudioStreamPlayer

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
