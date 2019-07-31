extends "res://UI/Menus/NestMenu.gd"

"""
Options Menu
	Node that displays a number of options during gameplay when the Player isn't in battle, from displaying status, to items, including Save and Load of the game.
	This Menu is considered the root of all the sub-options, thus when this NestMenu is erased, so will all other NestMenu that are opened.
"""

const ITEMS_MENU = preload("res://UI/Menus/ItemListMenu.tscn")

onready var npr = $NinePatchRect
onready var caret = $NinePatchRect/Caret
onready var options_list = $NinePatchRect/CenterContainer/VBoxContainer
onready var first_option = $NinePatchRect/CenterContainer/VBoxContainer/StatsButton

var last_focus = null

func _ready():
	._ready()
	get_tree().current_scene.bgm.volume_db = -20
	get_tree().paused = true
	for button in options_list.get_children():
		button.connect("focus_entered", self, "_on_Button_focus_entered")
		button.connect("pressed", self, "_on_Button_pressed", [button])
	first_option.grab_focus()

func _on_Button_pressed(button):
	sfx.sound(SFX_SELECT)
	match button.name:
		"StatsButton":
			statsOption()
		"ItemsButton":
			if PStats.items.size() > 0:
				self.focus = false
				var menu = ITEMS_MENU.instance()
				menu.rect_position.x = npr.rect_position.x + npr.rect_size.x + 4
				menu.rect_position.y = npr.rect_position.y
				menu.is_root = false
				menu.previous = self
				add_child(menu)
		"SaveButton":
			GData.save_game("game01.save")
			get_tree().current_scene.create_message_centered("Game Saved!")
		"LoadButton":
			if GData.load_game("game01.save"):
				var msg = get_tree().current_scene.create_message_centered("Game Loaded!")
				yield(msg, "message_done")
				get_tree().reload_current_scene()
			else:
				get_tree().current_scene.create_message_centered("There is no Saved Game!")
		"ExitButton":
			get_tree().quit()
	last_focus = button

func statsOption():
	var msg = get_tree().current_scene.create_message(npr.rect_position.x + npr.rect_size.x + 4, npr.rect_position.y, PStats.playerInfo(), false)
	hide()
	yield(msg, "message_done")
	show()
	self.focus = true
	

func destroy():
	.destroy()
	get_tree().current_scene.bgm.volume_db = -10
	get_tree().paused = false

func _on_Button_focus_entered():
	sfx.sound(SFX_MOVE)
	var focused = options_list.get_focus_owner()
	for button in options_list.get_children():
		if button == focused:
			button.modulate = Color(1,1,1)
		else:
			button.modulate = Color.thistle
	caret.rect_position.y = focused.rect_position.y + (focused.rect_size.y / 2)

func _on_Get_Focus():
	if last_focus: last_focus.grab_focus()