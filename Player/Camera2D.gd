extends Camera2D

onready var timer = $Timer

export (float) var amplitude = 6.0
export (float) var duration = 0.8 setget set_duration
export (float,EASE) var DAMP_EASING = 1.0
export (bool) var shake = false setget set_shake

func _ready():
	randomize()
	#set_process(false)
	self.duration = duration

func _process(delta):
	if shake:
		var damping = ease(timer.time_left / timer.wait_time, DAMP_EASING)
		offset = Vector2(
				rand_range(amplitude, -amplitude) * damping,
				rand_range(amplitude, -amplitude) * damping)

func set_duration(value):
	duration = value
	$Timer.wait_time = duration

func set_shake(value):
	shake = value
	#set_process(shake)
	offset = Vector2()
	if shake:
		timer.start()

func _on_Timer_timeout():
	self.shake = false
