extends MapEvent

"""
Show Dialog Event
	An Event Node to display a dialog window that shows String texts from a list, with a name tag of a character displayed on the top.
	You can select the character from its name as a String, or a path if it exists in the Scene Tree.
	(Optional) You can set if the camera centers on the speaking character.
"""

class_name ShowDialogEvent

export (String) var character_name
export (NodePath) var character_node
export (Array, String) var dialog_text
export (bool) var follow = true

var character

func interact():
	if not character_name and not character_node:
		emit_signal("finished")
		return
	if character_name:
		character = get_tree().current_scene.find_node(character_name, true, false)
	else:
		character = get_node(character_node)
	if not character:
		emit_signal("finished")
		return
	if follow:
		get_tree().current_scene.camera.follow(character)
	
	yield(get_tree(), "idle_frame")
	var dialog = get_tree().current_scene.find_node("Dialog", true, false)
	if dialog == null:
		dialog = load("res://UI/Dialog/Dialog.tscn").instance()
		get_tree().current_scene.add_child(dialog)
		GData.pause_enabled = false
		dialog.init(dialog_text, character.portrait, 12)
		#player.state = "talking_state"
		yield(dialog, "finished")
		GData.pause_enabled = true
	get_tree().current_scene.camera.follow()
	emit_signal("finished")