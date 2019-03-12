extends Node

var level
var _class
var items
var actions
var stats

var draw_health

func _ready():
	level = 1
	_class = gdata.classes["elizabeth"]
	
	items = {}
	actions = []
	stats = get_stats_from_class("elizabeth")
	
	draw_health = stats["health"]

func calculate_health(level, health):
	return round((health*3)+(level*3))

func get_stats_from_class(c):
	var stats = gdata.classes[c]
	stats["maxhealth"] = calculate_health(level, stats["health"])
	stats["health"] = stats["maxhealth"]
	if c == "elizabeth":
		stats["maxexperience"] = level * 10
	return stats