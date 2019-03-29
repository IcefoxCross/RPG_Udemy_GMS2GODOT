extends "res://UI/Menus/NestMenu.gd"

const ITEM_OPTIONS = preload("res://UI/Menus/ItemUseMenu.tscn")

onready var list = $NinePatchRect/MarginContainer/ItemList
onready var npr = $NinePatchRect

var options = []
var last_focus = null

func _ready():
	._ready()
	list.clear()
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
	return _options

func _on_ItemList_item_activated(index):
	self.focus = false
	var menu = ITEM_OPTIONS.instance()
	menu.rect_position.x = npr.rect_position.x + npr.rect_size.x + 4
	menu.rect_position.y = npr.rect_position.y
	menu.is_root = false
	menu.previous = self
	menu.item = options[index]
	add_child(menu)
	last_focus = index

func _on_Get_Focus():
	if last_focus: list.select(last_focus)