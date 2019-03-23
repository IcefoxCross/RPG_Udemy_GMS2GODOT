extends "res://UI/Menus/NestMenu.gd"

onready var caret = $NinePatchRect/Caret
onready var options_list = $NinePatchRect/CenterContainer/VBoxContainer
onready var first_option = $NinePatchRect/CenterContainer/VBoxContainer/StatsButton

func _ready():
	._ready()
	get_tree().paused = true
	for button in options_list.get_children():
		button.connect("focus_entered", self, "_on_Button_focus_entered")
		button.connect("pressed", self, "_on_Button_pressed")
	first_option.grab_focus()

func _on_Button_pressed():
	var focused = options_list.get_focus_owner()
	print(focused.name)

func _on_Button_focus_entered():
	var focused = options_list.get_focus_owner()
	for button in options_list.get_children():
		if button == focused:
			button.modulate = Color(1,1,1)
		else:
			button.modulate = Color.thistle
	caret.rect_position.y = focused.rect_position.y + (focused.rect_size.y / 2)
