extends Node

onready var wait_timer = $WaitTimer

var action
var last_room
var camera

func _ready():
	action = 0
	last_room = null
	
	for character in get_tree().get_nodes_in_group("character"):
		character.state = "cutscene_state"
		if character.is_in_group("player"):
			character.camera.state = "cutscene_state"
			camera = character.camera

func _process(delta):
	match action:
		0:
			move_to(get_tree().current_scene.player, 32, 0, true, get_tree().current_scene.player.move_speed, 5)
		1:
			move_to(get_tree().current_scene.player, 0, -16, true, get_tree().current_scene.player.move_speed, 0.5)
		_:
			destroy()

func destroy():
	get_tree().current_scene.player.state = "move_state"
	camera.state = null
	queue_free()

func wait(seconds):
	if wait_timer.is_stopped():
		wait_timer.wait_time = seconds
		wait_timer.one_shot = true
		wait_timer.start()

func move_to(character, x, y, relative, speed, wait_seconds):
	var cutscene = self
	if character == null:
		action += 1
		return
	else:
		get_tree().current_scene.camera.follow(character)
		if character.target == null:
			if relative:
				character.target = Vector2(character.position.x + x, character.position.y + y)
			else:
				character.target = Vector2(x,y)
			# Face target
			#var dir = Vector2(x,y).distance_to(character.target)
			character.spritedir = "down"
		var target_dir = Vector2(x,y).normalized()
		character.move_and_slide(target_dir * speed)
#		character.position.x = GData.approach(character.position.x, character.target.x, speed)
#		character.position.y = GData.approach(character.position.y, character.target.y, speed)
		
		# Reach target
		if character.position.distance_to(character.target) <= 0.5:
			character.position = character.target
			yield(get_tree().create_timer(wait_seconds), "timeout")
			action += 1

func _on_WaitTimer_timeout():
	action += 1
