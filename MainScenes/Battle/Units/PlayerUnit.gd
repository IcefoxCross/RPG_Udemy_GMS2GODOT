extends "res://MainScenes/Battle/Units/BattleUnit.gd"

func _ready():
	._ready()
	
	start("elizabeth", PStats.level, false, .8, .7, .6, 1)

func _process(delta):
	if level != PStats.level:
		self.level = PStats.level