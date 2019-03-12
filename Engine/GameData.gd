extends Node

var direction = {
	"center": Vector2(0,0),
	"left": Vector2(-1,0),
	"right": Vector2(1,0),
	"up": Vector2(0,-1),
	"down": Vector2(0,1)
}

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
		"monster": {
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