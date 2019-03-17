extends "res://MainScenes/Battle/Units/BattleUnit.gd"

func _ready():
	._ready()
	
	start("elizabeth", Stats.level, false, .8, .7, .8, .64)