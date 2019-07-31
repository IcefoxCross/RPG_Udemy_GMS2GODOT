extends "res://UI/Menus/NestMenu.gd"

"""
Item List Menu
	Displays what items the Player can use during battle, as you select one of the items pulled from the Player's inventory.
"""

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

func _input(event):
	if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right"):
		get_tree().set_input_as_handled()

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
		item["display"] = get_option_text(item)
		_options.append(item)
	return _options

func _on_ItemList_item_activated(index):
	sfx.sound(SFX_SELECT)
	self.focus = false
	var menu = ITEM_OPTIONS.instance()
	menu.rect_position.x = npr.rect_position.x + npr.rect_size.x + 4
	menu.rect_position.y = npr.rect_position.y
	menu.is_root = false
	menu.previous = self
	menu.item = options[index]
	menu.connect("item_updated", self, "update_list")
	add_child(menu)
	last_focus = index

func update_list():
	list.clear()
	options = create_items_option_list()
	for option in options:
		list.add_item(option["display"])
	if list.get_item_count() == 0:
		queue_free()
		previous.focus = true
	else:
		list.select(last_focus)

func get_option_text(item):
	var option_text = "x%s %s" % [item.amount, GData.items[item.name].name]
	if item.amount > 1:
		option_text = "x%s %ss" % [item.amount, GData.items[item.name].name]
	# Fit text to ui frame
	if option_text.length() > 13:
		option_text = "%s..." % option_text.substr(0, 10)
	return option_text

func _on_Get_Focus():
	list.grab_focus()
	sfx.sound(SFX_MOVE)
	if last_focus and list.get_item_count() > last_focus:
		list.select(last_focus)
	else:
		list.select(0)