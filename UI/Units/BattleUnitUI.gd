extends Control

"""
Battle Unit UI
	Displays basic information of the Unit is instanced to, including Health, Action bar, and its current Level.
"""

onready var info = $InfoBar
onready var action = $InfoBar/ActionMeter
onready var health = $InfoBar/HealthBar
onready var level = $InfoBar/LevelR

var unit

func _ready():
	unit = get_parent()
	info.rect_global_position.y = 106
	info.rect_position.x -= info.texture.get_width() / 2

func draw_level():
	level.text = str(unit.stats_object.level)

func draw_action():
	var index = (unit.action_meter / unit.max_action_meter) * ((action.hframes * action.vframes)-1)
	action.frame = index

func draw_health():
	var index = (unit.stats_object.draw_health / unit.stats_object.stats["maxhealth"]) * ((health.hframes * health.vframes)-1)
	health.frame = index