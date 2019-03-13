extends Node2D

var action_meter
var max_action_meter
var item_index
var state

func _ready():
	action_meter = 0
	max_action_meter = 100
	item_index = 0
	state = null
