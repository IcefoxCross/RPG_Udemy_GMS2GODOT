extends "res://MainScenes/Battle/Units/BattleUnit.gd"

export (String) var unit_name

func _ready():
	._ready()
	
	start(unit_name, 1, true, .7, .6, .8, .6)
