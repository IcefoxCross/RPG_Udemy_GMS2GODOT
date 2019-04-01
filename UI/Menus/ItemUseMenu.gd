extends "res://UI/Menus/NestMenu.gd"

onready var npr = $NinePatchRect
onready var caret = $NinePatchRect/Caret
onready var options_list = $NinePatchRect/CenterContainer/VBoxContainer
onready var first_option = $NinePatchRect/CenterContainer/VBoxContainer/UseButton
onready var info_option = $NinePatchRect/CenterContainer/VBoxContainer/InfoButton

signal item_updated

var item = null

func _ready():
	._ready()
	for button in options_list.get_children():
		button.connect("focus_entered", self, "_on_Button_focus_entered")
		button.connect("pressed", self, "_on_Button_pressed", [button])
	first_option.grab_focus()

func _on_Button_pressed(button):
	match button.name:
		"UseButton":
			useOption()
		"InfoButton":
			infoOption()
		"DropButton":
			dropOption()

func _on_Button_focus_entered():
	var focused = options_list.get_focus_owner()
	for button in options_list.get_children():
		if button == focused:
			button.modulate = Color(1,1,1)
		else:
			button.modulate = Color.thistle
	caret.rect_position.y = focused.rect_position.y + (focused.rect_size.y / 2) - 3

func useOption():
	var battler = get_tree().current_scene.find_node("PlayerUnit")
	if battler:
		battler.state = "use_item_state"
		battler.item_name = item.name
	else:
		PStats.use_item(item.name)
		var ev = InputEventAction.new()
		ev.action = "ui_cancel"
		ev.pressed = true
		Input.parse_input_event(ev)

func infoOption():
	var info = GData.items.get(item.name).info
	if info:
		var msg = get_tree().current_scene.create_message(rect_global_position.x, rect_global_position.y, info)
		msg.connect("message_done", self, "_message_done")
		hide()

func dropOption():
	PStats.drop_item(item.name, 1)
	emit_signal("item_updated")

func _message_done():
	show()
	info_option.grab_focus()