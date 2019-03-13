extends "res://Player/Camera2D.gd"

var speed
var state
var target = {}

func _ready():
	._ready()
	speed = .1
	position.x = 256
	state = null

func _process(delta):
	._process(delta)
	call(state)

func camera_approach(x,y,width,height,speed,zoom_speed):
	position = lerp(position, Vector2(x,y),speed)
	zoom = lerp(zoom,Vector2(Game.room_width/width,Game.room_height/height),zoom_speed)

func camera_screenshake(amount, duration):
	amplitude = amount
	duration = duration

func intro_state():
	target["x"] = Game.room_width *3/4
	target["y"] = Game.room_height
	
	if position.distance_to(Vector2(target["x"],target["y"])) < 1:
		position.x = target["x"]
		position.y = target["y"]
	
	state = "idle_state"

func idle_state():
	target["x"] = Game.room_width *3/4
	target["y"] = Game.room_height
	camera_approach(target["x"],target["y"],1,1,speed/2,speed)

func focus_state():
	camera_approach(target["x"], Game.room_height/2, 288, 162, speed/2, speed/2)
