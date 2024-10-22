extends MapEvent

"""
Move Event
	An Event Node to move a Character, either playable or non-playable, to a set position, either relavite to its current position,
or a set position on the map.
	You can select the character from its name as a String, or a path if it exists in the Scene Tree.
	You can select if the camera will follow the character when it moves.
	(Optional) you can set a Wait Time after changing the direction.
"""

class_name MoveEvent

export (String) var character_name
export (NodePath) var character_node

export (Vector2) var target
export (bool) var relative = true
export (bool) var follow = true
export (float) var wait_time = 0.0

var _character

func _ready():
	._ready()
	set_physics_process(false)

func _physics_process(delta):
	if relative:
		_character.position += target.normalized() * _character.move_speed * delta
	else:
		var vector = _character.target - _character.position
		_character.position += vector.normalized() * _character.move_speed * delta
	if _character.position.distance_to(_character.target) <= 0.5:
		_character.position = _character.target
		set_physics_process(false)
		yield(get_tree().create_timer(wait_time), "timeout")
		#player.state = "move_state"
		emit_signal("finished")
		get_tree().current_scene.camera.follow()

func interact():
	if not character_name and not character_node:
		emit_signal("finished")
		return
	if character_name:
		_character = get_tree().current_scene.find_node(character_name, true, false)
	else:
		_character = get_node(character_node)
	if not _character:
		emit_signal("finished")
		return
	#player.state = "cutscene_state"
	if follow:
		get_tree().current_scene.camera.follow(_character)
	if relative:
		_character.target = Vector2(_character.position.x + target.x, _character.position.y + target.y)
	else:
		_character.target = target
	_character.spritedir_set()
	set_physics_process(true)