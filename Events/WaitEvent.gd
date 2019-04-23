extends MapEvent

class_name WaitEvent

export (float) var wait_time

func interact():
	player.state = "cutscene_state"
	yield(get_tree().create_timer(wait_time), "timeout")
	player.state = "move_state"
	emit_signal("finished")