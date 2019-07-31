extends Node

"""
Events Parent Node
	The container Node of Single Events, it is necessary to execute a set of event in a top-down order.
	It will iterate through its child nodes and execute every interact() function, wait until it recieves a -finished- signal, then
execute the next one until there's none.
	To avoid executing the event more times than intended, a unique save key is created and stored in the Game Data, if it exists,
	the event is skipped.
"""

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