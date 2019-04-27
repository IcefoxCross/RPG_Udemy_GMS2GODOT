extends "res://MainScenes/Battle/Units/BattleUnit.gd"

export (String) var unit_name

func _ready():
	._ready()
	set_process_input(false)
	start(GData.b_enemy, GData.b_level, true, .9, .6, .8, 1.6)
	yield(get_tree().create_timer(1), "timeout")
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("end_battle"):
		destroy()
