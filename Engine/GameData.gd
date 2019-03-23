extends Node

### CONSTS ###
const BATTLE_SPACE = 160

### VARS ###
var pause_enabled

var direction = {
	"center": Vector2(0,0),
	"left": Vector2(-1,0),
	"right": Vector2(1,0),
	"up": Vector2(0,-1),
	"down": Vector2(0,1)
}

### FUNCS ###
func approach(start, end, shift):
	if (start < end):
		return min(start + shift, end)
	else:
		return max(start - shift, end)

func chance(perc):
	randomize()
	return 1 if (perc > randf()) else 0

func get_frames(x1, x2, speed):
	var dis = abs(x1-x2)
	return round(dis/speed)

func get_image_speed_from_frames(frames, image_number):
	return (9/(frames/image_number))

#### ROOM PERSISTENCE ####
var room_scene = null
var last_room = {
	"room" : "res://Rooms/Town.tscn",
	"x": 208,
	"y": 104,
	"dir": "right"
}

## NOT WORKING ##
var loaded_scene = false
func switch_scene(target_scene):
	room_scene = get_tree().current_scene
	get_tree().get_root().remove_child(room_scene)
	var new_scene = load(target_scene).instance()
	get_tree().get_root().add_child( new_scene )
	get_tree().set_current_scene( new_scene )

func load_scene():
	if room_scene != null:
		loaded_scene = true
		get_tree().current_scene.queue_free()
		get_tree().get_root().add_child(room_scene)
		room_scene = null

#### CLASSES ####
var classes = parse_json(get_class_data())

func get_class_data():
	var classes = {
		"elizabeth": {
			"name": "Elizabeth",
			"health": 10,
			"attack": 8,
			"defense": 8,
			"speed": 9,
			"critical": 25,
			"experience": 0,
			"actions": []
		},
		"spider": {
			"name": "Spider",
			"health": 3,
			"attack": 5,
			"defense": 4,
			"speed": 10,
			"critical": 5,
			"experience": 10,
			"actions": ["attack", "defend"]
		}
	}
	return to_json(classes)