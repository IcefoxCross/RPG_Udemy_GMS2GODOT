extends Node2D

onready var sprites = [$Sprite1,$Sprite2,$Sprite3,$Sprite4,
					$Sprite5,$Sprite6,$Sprite7,$Sprite8]

var camera
var x_start = []
var x_scale
var y_scale
var view_size

func _ready():
	camera = get_parent().find_node("BattleCamera")
	view_size = camera.get_viewport_rect().size
	x_start.append(sprites[0].position.x)
	x_start.append(sprites[1].position.x)
	x_start.append(sprites[2].position.x)
	x_start.append(sprites[3].position.x)
	x_start.append(sprites[4].position.x)
	x_start.append(sprites[5].position.x)
	x_start.append(sprites[6].position.x)
	x_start.append(sprites[7].position.x)
	
	sprites[7].position.x = 300

func _process(delta):
	x_scale = view_size.x / (Game.room_width/2)
	y_scale = view_size.y / Game.room_height
	
	# Sky
	sprites[0].position.x = camera.position.x
	sprites[0].position.y = camera.position.y
	sprites[0].scale.x = x_scale
	sprites[0].scale.y = y_scale
	
	# Mountains
	sprites[1].position.x = (camera.position.x / 1.1) + x_start[1]
	sprites[1].position.y = camera.position.y
	
	# Others
	sprites[2].position.x = (camera.position.x / 2) + x_start[2]
	sprites[2].position.y = camera.position.y
	sprites[3].position.x = (camera.position.x / 2.75) + x_start[3]
	sprites[3].position.y = camera.position.y
	sprites[4].position.y = camera.position.y
	sprites[5].position.x = x_start[5] - (camera.position.x / 2.75)
	sprites[5].position.y = camera.position.y
	sprites[6].position.x = x_start[6] - camera.position.x
	sprites[6].position.y = camera.position.y
	sprites[7].position.x = x_start[7] - (camera.position.x / 0.8)
	sprites[7].position.y = camera.position.y
