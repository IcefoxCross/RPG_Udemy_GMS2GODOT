extends "res://MainScenes/Battle/Units/BattleUnit.gd"

"""
Player Unit Node
	Inherits from Battle Unit, performs actions based on what is selected in its BattleUI.
"""

func _ready():
	._ready()
	
	start("elizabeth", PStats.level, false, .8, .7, .6, 1)

func _process(delta):
	if level != PStats.level:
		self.level = PStats.level