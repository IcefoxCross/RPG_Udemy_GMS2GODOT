extends "res://MainScenes/Battle/Units/BattleUnit.gd"

func _ready():
	._ready()
	
	start("elizabeth", Stats.level, false, .8, .64, .8, .64)