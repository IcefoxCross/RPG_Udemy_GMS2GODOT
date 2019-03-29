extends "res://UI/Menus/NestMenu.gd"

const ITEMS_MENU = preload("res://UI/Menus/ItemListMenu.tscn")

onready var npr = $NinePatchRect
onready var caret = $NinePatchRect/Caret
onready var options_list = $NinePatchRect/CenterContainer/VBoxContainer
onready var first_option = $NinePatchRect/CenterContainer/VBoxContainer/StatsButton

var last_focus = null

func _ready():
	._ready()
	get_tree().paused = true
	for button in options_list.get_children():
		button.connect("focus_entered", self, "_on_Button_focus_entered")
		button.connect("pressed", self, "_on_Button_pressed", [button])
	first_option.grab_focus()

func _on_Button_pressed(button):
	match button.name:
		"ItemsButton":
			self.focus = false
			var menu = ITEMS_MENU.instance()
			menu.rect_position.x = npr.rect_position.x + npr.rect_size.x + 4
			menu.rect_position.y = npr.rect_position.y
			menu.is_root = false
			menu.previous = self
			add_child(menu)
	last_focus = button

func _on_Button_focus_entered():
	var focused = options_list.get_focus_owner()
	for button in options_list.get_children():
		if button == focused:
			button.modulate = Color(1,1,1)
		else:
			button.modulate = Color.thistle
	caret.rect_position.y = focused.rect_position.y + (focused.rect_size.y / 2)

func _on_Get_Focus():
	if last_focus: last_focus.grab_focus()