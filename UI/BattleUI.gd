extends Control

onready var frame = $Frame
onready var options = $Frame/HBoxContainer

var target_y
var enabled
var Player

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
			options.get_children()[0].grab_focus()

func _on_Button_Pressed(option):
	print(option.name)
	if Player and enabled:
		match option.name:
			"ActionIcon":
				Player.state = "approach_state"
				option.release_focus()

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
