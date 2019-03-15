extends Control

onready var info = $InfoBar

var unit

func _ready():
	unit = get_parent()
	info.rect_global_position.y = 106
	info.rect_position.x -= info.texture.get_width() / 2