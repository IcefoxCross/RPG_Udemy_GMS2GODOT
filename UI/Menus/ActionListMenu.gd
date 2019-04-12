extends "res://UI/Menus/NestMenu.gd"

const ACTION_OPTIONS = preload("res://UI/Menus/ActionUseMenu.tscn")
const CARET = preload("res://UI/Assets/s_ui_caret_0.png")

onready var list = $NinePatchRect/MarginContainer/ItemList
onready var npr = $NinePatchRect

var options = []
var last_focus = null

func _ready():
	._ready()
	list.clear()
	npr.rect_size = Vector2(80,44)
	options = create_actions_option_list()
	for option in options:
		list.add_item(option["display"])
	if list.get_item_count() > 0:
		list.grab_focus()
		list.select(0)

func _input(event):
	if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right"):
		get_tree().set_input_as_handled()

func create_actions_option_list():
	var _options = []
	var actions_list = PStats.actions

	for i in range(actions_list.size()):
		var action = {
			"name": actions_list[i]
		}
		action["display"] = GData.actions[action["name"]].name
		_options.append(action)
	return _options

func _on_ItemList_item_activated(index):
	self.focus = false
	var menu = ACTION_OPTIONS.instance()
	menu.rect_position.x = npr.rect_position.x + npr.rect_size.x + 4
	menu.rect_position.y = npr.rect_position.y
	menu.is_root = false
	menu.previous = self
	menu.action = options[index]
	add_child(menu)
	last_focus = index

func _on_Get_Focus():
	list.grab_focus()
	if last_focus and list.get_item_count() > last_focus:
		list.select(last_focus)
	else:
		list.select(0)