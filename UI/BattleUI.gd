extends Control

"""
Battle UI
	This Node dictates which Action will the Player perform, being able to select attack, defense, use an item, or run from the current battle.
	Only appears and can be selected when the Player Unit is in the Action State.
"""

const ITEMS_MENU = preload("res://UI/Menus/ItemListMenu.tscn")
const ACTIONS_MENU = preload("res://UI/Menus/ActionListMenu.tscn")

const SFX_MOVE = "res://Audio/SFX/menu_move.wav"
const SFX_SELECT = "res://Audio/SFX/menu_select.wav"

onready var frame = $Frame
onready var options = $Frame/HBoxContainer
onready var sfx = $SFX

var target_y
var enabled
var Player
var focus setget set_focus

func _ready():
	frame.rect_position.y = 204
	for option in options.get_children():
		option.connect("pressed", self, "_on_Button_Pressed", [option])
		option.connect("focus_entered", self, "_on_Focus_Entered", [option])
		option.modulate = Color8(128,128,128)

func _process(delta):
	Player = get_tree().current_scene.find_node("PlayerUnit")
	if Player:
		target_y = 140 + (int(Player.state != "action_state") * 64)
		enabled = Player.state == "action_state"
	else:
		target_y = 204
	frame.rect_position.y = lerp(frame.rect_position.y, target_y, .1)
	if frame.rect_position.distance_to(Vector2(frame.rect_position.x, 140)) <= 16:
		if options.get_focus_owner() == null and enabled:
			if has_node("ItemListMenu"):
				options.get_children()[1].grab_focus()
			else:
				options.get_children()[0].grab_focus()

func _on_Button_Pressed(option):
	if Player and enabled:
		sfx.sound(SFX_SELECT)
		match option.name:
			"ActionIcon":
				enabled = false
				var menu = ACTIONS_MENU.instance()
				menu.rect_position.x = frame.rect_global_position.x + 13
				menu.rect_position.y = target_y - frame.rect_size.y - 8
				menu.is_root = false
				menu.previous = self
				var focused = options.get_focus_owner()
				focused.release_focus()
				add_child(menu)
			"ItemIcon":
				enabled = false
				if PStats.items.size() > 0:
					var menu = ITEMS_MENU.instance()
					menu.rect_position.x = frame.rect_global_position.x + 13
					menu.rect_position.y = target_y - frame.rect_size.y * 2
					menu.is_root = false
					menu.previous = self
					menu.connect("erased", self, "_on_ItemList_Erased")
					var focused = options.get_focus_owner()
					focused.release_focus()
					add_child(menu)
			"RunIcon":
				enabled = false
				Player.state = "wait_state"
				get_tree().current_scene._on_end_battle()

func _on_ItemList_Erased():
	options.get_children()[1].grab_focus() 

func set_focus(value):
	focus = value
	if focus: emit_signal("focus_entered")

func _on_Focus_Entered(option):
	var focused = options.get_focus_owner()
	if not enabled:
		focused.release_focus()
		return
	sfx.sound(SFX_MOVE)
	for button in options.get_children():
		if button == focused:
			button.modulate = Color.white
		else:
			button.modulate = Color8(128,128,128)
