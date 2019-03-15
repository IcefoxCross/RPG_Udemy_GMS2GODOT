extends Node

var direction = {
	"center": Vector2(0,0),
	"left": Vector2(-1,0),
	"right": Vector2(1,0),
	"up": Vector2(0,-1),
	"down": Vector2(0,1)
}


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