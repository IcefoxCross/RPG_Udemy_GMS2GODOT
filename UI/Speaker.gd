extends "res://Rooms/Objects/Interactible.gd"

var dialog
var dialog_object
var dialog_page
var dialog_state
var portrait
var text = []

func _ready():
	dialog = null
	# dialog_object can be cutscene
	dialog_object = load("res://UI/Dialog/Dialog.tscn")
	dialog_page = 0
	dialog_state = 0
	
	portrait = load("res://UI/Assets/Dialog/s_default_portrait_0.png")
	text = ["Empty"]

func interact(body):
	.interact(body)
	if dialog == null:
		dialog = dialog_object.instance()
		dialog.connect("finished", self, "free_dialog")
		get_tree().current_scene.add_child(dialog)
		GData.pause_enabled = false
		
		if dialog.name == "Dialog":
			dialog.init(text, portrait, 12)
			other.state = "talking_state"

func free_dialog():
	dialog = null
	GData.pause_enabled = true