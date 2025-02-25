extends Node

"""
Player Stats Node
An Autoload node that keeps and manages information from the playable character, including:
	experience and level up, health and stats calculation, item handling (add, use, drop)
"""

var level
var _class
var items
var actions
var stats

var defend = false

var draw_health

func _ready():
	level = 1
	_class = GData.classes["elizabeth"].duplicate()
	
	items = {}
	actions = []
	actions.append("attack")
	actions.append("defend")
	actions.append("fire spell")
	actions.append("sonar spell")
	stats = get_stats_from_class("elizabeth")
	pickup_item("potion",3)
	
	draw_health = stats["health"]

func _process(delta):
	update_draw_health()
	# Level up
	if stats["experience"] >= stats["maxexperience"]:
		if not get_tree().current_scene.has_node("LevelUp"):
			var levelup = load("res://UI/LevelUp/LevelUp.tscn").instance()
			var camera = get_tree().current_scene.find_node("BattleCamera")
			levelup.position = camera.get_camera_screen_center()
			get_tree().current_scene.add_child(levelup)
			if get_tree().current_scene.has_node("FadeTransition"):
				var fade = get_tree().current_scene.get_node("FadeTransition")
				fade.queue_free()
		
		level += 1
		stats["experience"] = stats["experience"] - stats["maxexperience"]
		stats["maxexperience"] = level * 10
		stats["health"] = calculate_health(level, _class["health"])
		stats["maxhealth"] = stats["health"]

func calculate_health(level, health):
	return round((health*3)+(level*3))

func get_stats_from_class(c):
	var stats
	if c == "elizabeth":
		stats = GData.classes[c]
	else:
		stats = GData.classes[c].duplicate()
	stats["maxhealth"] = calculate_health(level, stats["health"])
	stats["health"] = stats["maxhealth"]
	if c == "elizabeth":
		stats["maxexperience"] = level * 10
	return stats

func update_draw_health():
	var dis = draw_health - stats["health"]
	if dis > 1:
		draw_health = lerp(draw_health, stats["health"], .1)
	else:
		draw_health = stats["health"]

func playerInfo():
	var info = ""
	info += stats["name"]
	info += "\nLevel: %s" % level
	info += "\nNext Level: %s exp" % (stats["maxexperience"] - stats["experience"])
	info += "\nHealth: %s / %s" % [stats["health"], stats["maxhealth"]]
	return info

### ITEMS ###
func pickup_item(item, amount):
	if items.has(item):
		items[item] += amount
	else:
		items[item] = amount

func drop_item(item, amount):
	if items.has(item):
		items[item] -= amount
		if items[item] <= 0:
			items.erase(item)

func use_item(item):
	if items.has(item):
		var _item = GData.items[item]
		# Exit case
		if _item["battle"] and get_tree().current_scene.name != "Battle":
			get_tree().current_scene.create_message_centered("You cannot use this\nitem outside of battle.")
			return
		drop_item(item, 1)
		GData.call(_item["effect"], _item["arguments"])