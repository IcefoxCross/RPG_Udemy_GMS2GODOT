extends Node2D

const SHINE = preload("res://UI/Effects/Shine.tscn")
const ARROW = preload("res://UI/LevelUp/LevelUpArrow.tscn")

onready var sprite = $Sprite
onready var anim = $AnimationPlayer
onready var timer = $Timer

func _ready():
	randomize()

func _process(delta):
	if anim.current_animation_position == anim.current_animation_length:
		if GData.chance(0.2):
			var shine = SHINE.instance()
			var x = int(rand_range(sprite.get_rect().position.x, sprite.get_rect().end.x))
			var y = int(rand_range(sprite.get_rect().position.y, sprite.get_rect().end.y))
			shine.position = Vector2(x,y)
			add_child(shine)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim.playback_speed > 0:
		timer.wait_time = 2
		timer.start()
		anim.playback_speed = 0
		var arrow = ARROW.instance()
		arrow.position = Vector2(sprite.get_rect().position.x, sprite.position.y)
		add_child(arrow)
		var arrow2 = ARROW.instance()
		arrow2.position = Vector2(sprite.get_rect().end.x, sprite.position.y)
		add_child(arrow2)


func _on_Timer_timeout():
	queue_free()
	get_tree().current_scene.end_battle()