extends Control

const ITEMS_MENU = preload("res://UI/Menus/ItemListMenu.tscn")

onready var frame = $Frame
onready var options = $Frame/HBoxContainer

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
		match option.name:
			"ActionIcon":
				Player.state = "approach_state"
				option.release_focus()
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
	for button in options.get_children():
		if button == focused:
			button.modulate = Color.white
		else:
			button.modulate = Color8(128,128,128)
