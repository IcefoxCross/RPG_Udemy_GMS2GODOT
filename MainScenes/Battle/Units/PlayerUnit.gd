extends "res://MainScenes/Battle/Units/BattleUnit.gd"

func _ready():
	._ready()
	
	start("elizabeth", PStats.level, false, .8, .7, .8, .64)