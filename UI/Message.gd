extends PanelContainer

onready var npr = $NinePatchRect
onready var text = $MarginContainer/Text

var cutscene = null

func _ready():
	#initialize(16,16,"Level Up!\nCheck the Menu for details.")
	initialize_centered("Level Up!\nCheck the Menu for details.")
#	text.text = "Level Up!"
#	rect_size.y += 12
#	margin_left -= 8
#	margin_right += 8
#	rect_position.y = 8

func initialize(x,y,msg):
	rect_position = Vector2(x,y)
	text.text = msg

func initialize_centered(msg):
	text.text = msg
	var width = ProjectSettings.get_setting("display/window/size/width")
	var height = ProjectSettings.get_setting("display/window/size/height")
	yield(self,"resized")
	rect_position = Vector2((width/2) - (rect_size.x / 2),(height/2) - (rect_size.y / 2))

func _input(event):
	if event.is_action_pressed("action") or event.is_action_pressed("back"):
		get_tree().set_input_as_handled()
		if cutscene:
			cutscene.action += 1
		queue_free()


func _on_Timer_timeout():
	if cutscene:
		cutscene.action += 1
	queue_free()
