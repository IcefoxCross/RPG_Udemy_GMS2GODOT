extends MapEvent

class_name FaceDirectionEvent

export (String) var character_name
export (NodePath) var character_node
export (String, "up", "down", "left", "right") var facing
export (float) var wait_time = 0.0

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
	
	#player.state = "cutscene_state"
	character.spritedir = facing
	yield(get_tree().create_timer(wait_time), "timeout")
	emit_signal("finished")