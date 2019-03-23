extends Control

#signal closed

var pause_state
var focus setget set_focus
var is_root = true
var previous

func _ready():
	self.focus = true

func _input(event):
#	if event.is_action_pressed("ui_left"):
#		rect_position.x -= 8
#		get_tree().set_input_as_handled()
#	if event.is_action_pressed("ui_right"):
#		rect_position.x += 8
#		get_tree().set_input_as_handled()
	if event.is_action_pressed("ui_cancel"):
		if is_root and gdata.pause_enabled:
			pause_state = not get_tree().paused
			get_tree().paused = pause_state
			visible = pause_state
			get_tree().set_input_as_handled()
#			if not visible:
#				self.focus = true
#		elif not is_root:
		queue_free()
	if event.is_action_pressed("back"):
		if get_tree().paused:
			if not is_root:
				previous.focus = true
			else:
				get_tree().paused = false
				visible = false
			queue_free()
			get_tree().set_input_as_handled()
#	if event.is_action_pressed("action"):
#		if get_tree().paused and focus:
#			self.focus = false
#			var menu = load("res://UI/Menus/NestMenu.tscn").instance()
#			menu.rect_position.x = rect_position.x + 16
#			menu.rect_position.y = rect_position.y + 16
#			menu.is_root = false
#			menu.previous = self
#			get_parent().add_child(menu)

func set_focus(value):
	focus = value
	$NinePatchRect/ColorRect.visible = not value