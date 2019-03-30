extends Node

var level
var _class
var items
var actions
var stats

var draw_health

func _ready():
	level = 3
	_class = GData.classes["elizabeth"]
	
	items = {}
	actions = []
	stats = get_stats_from_class("elizabeth")
	pickup_item("potion",2)
	
	draw_health = stats["health"]

func _process(delta):
	update_draw_health()
	# Update stats for death and level up
	if draw_health <= 0:
		get_tree().change_scene("res://MainScenes/GameOver.tscn")
	# Level up
	if stats["experience"] >= stats["maxexperience"]:
		level += 1
		stats["experience"] = stats["experience"] - stats["maxexperience"]
		stats["maxexperience"] = level * 10
		stats["health"] = calculate_health(level, _class["health"])
		stats["maxhealth"] = stats["health"]

func calculate_health(level, health):
	return round((health*3)+(level*3))

func get_stats_from_class(c):
	var stats = GData.classes[c]
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