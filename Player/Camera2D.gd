extends Camera2D

onready var timer = $Timer

export (float) var amplitude = 6.0
export (float) var duration = 0.8 setget set_duration
export (float,EASE) var DAMP_EASING = 1.0
export (bool) var shake = false setget set_shake

var state

var target = null

func _ready():
	randomize()
	#set_process(false)
	self.duration = duration

func _process(delta):
	if target != null:
		global_position = target.global_position
	if shake:
		var damping = ease(timer.time_left / timer.wait_time, DAMP_EASING)
		offset = Vector2(
				rand_range(amplitude, -amplitude) * damping,
				rand_range(amplitude, -amplitude) * damping)

func follow(target_node):
	if target_node == null:
		target = get_parent()
	else:
		target = target_node

func camera_approach(x,y,width,height,speed,zoom_speed):
	position.x = lerp(position.x, x,speed)
	position.y = lerp(position.y, y,speed)
	#zoom = lerp(zoom,Vector2(width/Game.room_width,height/Game.room_height),zoom_speed)
	zoom = lerp(zoom,Vector2(width,height),zoom_speed)

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
