extends "res://NPCS/Character.gd"

"""
Adam
	Instanced Character with unique dialog and portrait
"""

func _ready():
	._ready()
	
	dialog_object = load("res://UI/Dialog/Dialog.tscn")
	portrait = load("res://NPCS/Adam/s_adam_portrait_0.png")
	
	text = ["Hey Elizabeth!", "How are you today?"]
