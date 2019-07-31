extends Control

"""
Nest Menu
	Basic Control Node that can hold instances of the same Node as child, and be displayed on top of it, to created a nested system of submenus.
	When the Instanced NestMenu is erased, the focus is returned to its parent NestMenu, to keep a hierarchical order.
	If the NestMenu was the root of all of the other ones, they are all destroyed, spreading the action to its NestMenu children.
	Must not be used directly, instead create an Inherited Scene from this, and implement its unique functionality.
"""

const SFX_MOVE = "res://Audio/SFX/menu_move.wav"
const SFX_SELECT = "res://Audio/SFX/menu_select.wav"

signal get_focus
signal erased

onready var foreground = $NinePatchRect/ColorRect
onready var sfx = $SFX

var pause_state
var focus setget set_focus
var is_root = true
var previous

func _ready():
	self.focus = true
	connect("get_focus", self, "_on_Get_Focus")

func _input(event):
#	if event.is_action_pressed("ui_left"):
#		rect_position.x -= 8
#		get_tree().set_input_as_handled()
#	if event.is_action_pressed("ui_right"):
#		rect_position.x += 8
#		get_tree().set_input_as_handled()
	if event.is_action_pressed("ui_cancel"):
		if is_root and GData.pause_enabled:
			pause_state = not get_tree().paused
			get_tree().paused = pause_state
			visible = pause_state
			get_tree().set_input_as_handled()
#			if not visible:
#				self.focus = true
#		elif not is_root:
		destroy()
	if event.is_action_pressed("back"):
		if get_tree().paused or get_tree().current_scene.name == "Battle":
			if not is_root:
				previous.focus = true
			else:
				get_tree().paused = false
				visible = false
			destroy()
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

func destroy():
	queue_free()
	emit_signal("erased")

func set_focus(value):
	focus = value
	foreground.visible = not value
	if focus: emit_signal("get_focus")

func _on_Get_Focus():
	pass