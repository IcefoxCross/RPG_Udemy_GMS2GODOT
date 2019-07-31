extends "res://UI/Menus/NestMenu.gd"

"""
Action Use Menu
	Displays what can the Player do with the selected Action, be it being used, or displaying a Message with information about what it does.
"""

onready var npr = $NinePatchRect
onready var caret = $NinePatchRect/Caret
onready var options_list = $NinePatchRect/CenterContainer/VBoxContainer
onready var use_option = $NinePatchRect/CenterContainer/VBoxContainer/UseButton
onready var info_option = $NinePatchRect/CenterContainer/VBoxContainer/InfoButton

signal item_updated

var action = null

func _ready():
	._ready()
	for button in options_list.get_children():
		button.connect("focus_entered", self, "_on_Button_focus_entered")
		button.connect("pressed", self, "_on_Button_pressed", [button])
	use_option.grab_focus()

func _on_Button_pressed(button):
	get_tree().current_scene.sfx.sound(SFX_SELECT)
	match button.name:
		"UseButton":
			useOption()
		"InfoButton":
			infoOption()

func _on_Button_focus_entered():
	sfx.sound(SFX_MOVE)
	var focused = options_list.get_focus_owner()
	for button in options_list.get_children():
		if button == focused:
			button.modulate = Color(1,1,1)
		else:
			button.modulate = Color.thistle
	caret.rect_position.y = focused.rect_position.y + (focused.rect_size.y / 2)

func useOption():
	var battler = get_tree().current_scene.find_node("PlayerUnit")
	if battler:
		if action.name == "defend":
			battler.call(GData.actions[action.name].action)
		else:
			battler.state = GData.actions[action.name].action
	var ev = InputEventAction.new()
	ev.action = "ui_cancel"
	ev.pressed = true
	Input.parse_input_event(ev)

func infoOption():
	var info = GData.actions.get(action.name).info
	if info:
		var msg = get_tree().current_scene.create_message(rect_global_position.x, rect_global_position.y, info)
		msg.connect("message_done", self, "_message_done")
		hide()

func _message_done():
	show()
	info_option.grab_focus()