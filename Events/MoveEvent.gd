extends MapEvent

class_name MoveEvent

export (String) var character

export (Vector2) var target
export (bool) var relative = true
export (float) var wait_time = 0.0

var _character

func _ready():
	._ready()
	set_physics_process(false)

func _physics_process(delta):
	_character.position += target.normalized() * _character.move_speed * delta
	if _character.position.distance_to(_character.target) <= 0.5:
		_character.position = _character.target
		set_physics_process(false)
		yield(get_tree().create_timer(wait_time), "timeout")
		player.state = "move_state"
		emit_signal("finished")

func interact():
	if character == null:
		_character = self
	else:
		_character = get_tree().current_scene.find_node(character, true, false)
	if not _character:
		emit_signal("finished")
		return
	player.state = "cutscene_state"
	get_tree().current_scene.camera.follow(_character)
	if relative:
		_character.target = Vector2(_character.position.x + target.x, _character.position.y + target.y)
	else:
		_character.target = target
	_character.spritedir_set()
	set_physics_process(true)