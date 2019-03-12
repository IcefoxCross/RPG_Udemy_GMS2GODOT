extends Node2D

const BATTLE = preload("res://UI/BattleTransition.tscn")

func _ready():
	var fade = BATTLE.instance()
	get_tree().current_scene.add_child(fade)
	fade.fade(0)
