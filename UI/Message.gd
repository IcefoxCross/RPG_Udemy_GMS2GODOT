extends PanelContainer

onready var npr = $NinePatchRect
onready var textbox = $MarginContainer/Text

signal message_done

func _ready():
	pass
	#initialize(16,16,"Level Up!\nCheck the Menu for details.")
	#initialize_centered("Level Up!\nCheck the Menu for details.")
#	text.text = "Level Up!"
#	rect_size.y += 12
#	margin_left -= 8
#	margin_right += 8
#	rect_position.y = 8

func initialize(x,y,msg, timed):
	textbox.text = msg
	rect_position = Vector2(x,y)
	if timed: $Timer.start()

func initialize_centered(msg, timed = true):
	textbox.text = msg
	var width = ProjectSettings.get_setting("display/window/size/width")
	var height = ProjectSettings.get_setting("display/window/size/height")
	yield(self,"resized")
	rect_position = Vector2((width/2) - (rect_size.x / 2),(height/2) - (rect_size.y / 2))
	if timed: $Timer.start()

func _input(event):
	if event.is_action_pressed("action") or event.is_action_pressed("back") or event.is_action_pressed("ui_cancel"):
		if not event.is_action_pressed("ui_cancel"):
			get_tree().set_input_as_handled()
		queue_free()
		emit_signal("message_done")


func _on_Timer_timeout():
	queue_free()
	emit_signal("message_done")
