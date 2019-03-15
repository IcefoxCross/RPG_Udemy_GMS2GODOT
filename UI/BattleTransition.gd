extends CanvasLayer

export (float) var duration = 1.0

onready var rect = $Control/ColorRect
onready var tween = $Control/Tween

signal fade_done

func _ready():
#	if get_tree().current_scene.name == "Battle":
#		rect.modulate.a = 1
#	else:
	rect.modulate.a = 0

func fade(alpha):
	if alpha == 0:
		rect.modulate.a = 1
	var target_color = rect.modulate
	target_color.a = alpha
	tween.interpolate_property(rect, "modulate", rect.modulate, target_color,duration,Tween.TRANS_SINE,Tween.EASE_OUT)
	tween.start()
	yield(tween,"tween_completed")
	if rect.modulate.a == 0:
		queue_free()
	else:
		emit_signal("fade_done")