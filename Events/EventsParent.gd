extends Node

signal finished

var player
var parent

func interact():
	player = get_tree().get_nodes_in_group("player")[0]
	parent = get_parent().get_parent()
	if GData.save_data["keys"].has(GData.save_key(parent,self)):
		emit_signal("finished")
		return
	if get_child_count() > 0:
		player.state = "cutscene_state"
		for event in get_children():
			event.interact()
			yield(event, "finished")
		GData.save_data["keys"][GData.save_key(parent, self)] = true
		player.state = "move_state"
	emit_signal("finished")