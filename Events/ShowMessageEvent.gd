extends MapEvent

"""
Show Message Event
	An Event Node to display a message window that shows a String text intended for short messages. For several lines of text,
a Show Dialog Event is recommended.
	If the message won't be Centered, you can select the position of the message in the screen.
"""

class_name ShowMessageEvent

export (String, MULTILINE) var text
export (bool) var centered
export (Vector2) var text_position

func interact():
	if not text:
		emit_signal("finished")
		return
	
	yield(get_tree(), "idle_frame")
	var message = get_tree().current_scene.find_node("Message", true, false)
	if message == null:
		message = load("res://UI/Message.tscn").instance()
		var gui = get_tree().current_scene.find_node("GUI", true, false)
		if gui:
			gui.add_child(message)
		else:
			get_tree().current_scene.add_child(message)
		if centered:
			message.initialize_centered(text)
		else:
			message.initialize(text_position.x, text_position.y, text)
		GData.pause_enabled = false
		#player.state = "cutscene_state"
		yield(message, "message_done")
		GData.pause_enabled = true
	emit_signal("finished")