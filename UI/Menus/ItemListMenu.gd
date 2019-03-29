extends "res://UI/Menus/NestMenu.gd"

onready var list = $NinePatchRect/MarginContainer/ItemList
onready var npr = $NinePatchRect

var options = []

func _ready():
	._ready()
	list.clear()
	npr.rect_position = Vector2(16,16)
	npr.rect_size = Vector2(96,64)
	options = create_items_option_list()
	for option in options:
		list.add_item(option["display"])
	if list.get_item_count() > 0:
		list.grab_focus()
		list.select(0)

func create_items_option_list():
	var _options = []
	var items_list = PStats.items

	for i in range(items_list.size()):
		var item = {
			"name": items_list.keys()[i],
			"amount": items_list.values()[i],
			"script": null
		}
		#var item = items_list[items_list.keys()[i]]
		var option_text = "x%s %s" % [item.amount, GData.items[item.name].name]
		if item.amount > 1:
			option_text = "x%s %ss" % [item.amount, GData.items[item.name].name]
		# Fit text to ui frame
		if option_text.length() > 13:
			option_text = "%s..." % option_text.substr(0, 10)
		item["display"] = option_text
		_options.append(item)
	print(_options)
	return _options