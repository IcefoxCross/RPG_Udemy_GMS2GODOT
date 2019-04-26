extends Node

### CONSTS ###
const BATTLE_SPACE = 160

### VARS ###
var pause_enabled

var direction = {
	"center": Vector2(0,0),
	"left": Vector2(-1,0),
	"right": Vector2(1,0),
	"up": Vector2(0,-1),
	"down": Vector2(0,1)
}

var save_data = {
	"keys": {}
}
var loaded = false

### FUNCS ###
func approach(start, end, shift):
	if (start < end):
		return min(start + shift, end)
	else:
		return max(start - shift, end)

func chance(perc):
	randomize()
	return 1 if (perc > randf()) else 0

func get_frames(x1, x2, speed):
	var dis = abs(x1-x2)
	return round(dis/speed)

func save_key(node, node2):
	return "%s%s%s%s%s" % [get_tree().current_scene.current_room.name, node.name, node.position.x, node.position.y, node2.name]

func get_image_speed_from_frames(frames, image_number):
	return (9/(frames/image_number))

#### ROOM PERSISTENCE ####
var room_scene = null
var last_room = {
	"room" : "res://Rooms/Town.tscn",
	"x": 128,
	"y": 104,
	"dir": "right"
}

## NOT WORKING ##
var loaded_scene = false
func switch_scene(target_scene):
	room_scene = get_tree().current_scene
	get_tree().get_root().remove_child(room_scene)
	var new_scene = load(target_scene).instance()
	get_tree().get_root().add_child( new_scene )
	get_tree().set_current_scene( new_scene )

func load_scene():
	if room_scene != null:
		loaded_scene = true
		get_tree().current_scene.queue_free()
		get_tree().get_root().add_child(room_scene)
		room_scene = null

#### SAVE / LOAD ####
func save_game(file_name):
	# Break cases
	var player = get_tree().current_scene.find_node("Elizabeth")
	if not player:
		print("Error: player not found")
		return
	
	# Save room
	save_data["room"] = get_tree().current_scene.current_room.filename
	# Save Player position
	save_data["playerx"] = player.position.x
	save_data["playery"] = player.position.y
	save_data["playerdir"] = player.spritedir
	# Save Player stats
	save_data["level"] = PStats.level
	save_data["items"] = PStats.items
	
	# Save Data
	var save_file = File.new()
	save_file.open("user://%s" % file_name, File.WRITE)
	save_file.store_line(to_json(save_data))
	save_file.close()

func load_game(file_name):
	# Break cases
	var player = get_tree().current_scene.find_node("Elizabeth")
	if not player:
		print("Error: player not found")
		return
	
	# Load Data
	var save_file = File.new()
	if save_file.file_exists("user://%s" % file_name):
		save_file.open("user://%s" % file_name, File.READ)
		var data = parse_json(save_file.get_line())
		save_file.close()
		# Load Room
		last_room["room"] = data["room"]
		last_room["x"] = data["playerx"]
		last_room["y"] = data["playery"]
		last_room["dir"] = data["playerdir"]
		# Load Player Stats
		PStats.level = data["level"]
		PStats.items = data["items"]
		PStats.stats = PStats.get_stats_from_class("elizabeth")
		PStats.draw_health = PStats.stats["health"]
		# Load Keys
		save_data["keys"] = data["keys"]
		return true
	else:
		return false

#### CLASSES ####
var classes = parse_json(get_class_data())

func get_class_data():
	var classes = {
		"elizabeth": {
			"name": "Elizabeth",
			"health": 10,
			"attack": 8,
			"defense": 8,
			"speed": 9,
			"critical": 25,
			"experience": 0,
			"actions": []
		},
		"spider": {
			"name": "Spider",
			"health": 3,
			"attack": 5,
			"defense": 4,
			"speed": 10,
			"critical": 5,
			"experience": 10,
			"actions": ["attack", "defend"]
		},
		"gargoyle": {
			"name": "Gargoyle",
			"health": 10,
			"attack": 4,
			"defense": 8,
			"speed": 4,
			"critical": 10,
			"experience": 100,
			"actions": ["sonar spell", "defend"]
		}
	}
	return to_json(classes)

#### ACTIONS ####
var actions = parse_json(get_action_data())

func get_action_data():
	var actions = {
		"attack": {
			"name": "Attack",
			"action": "approach_state",
			"info": "A basic melee\nattack."
		},
		"defend": {
			"name": "Defend",
			"action": "action_defend",
			"info": "Reduces damage taken\nby half and sets\naction bar to half."
		},
		"fire spell": {
			"name": "Fire Spell",
			"action": "fire_spell_state",
			"info": "Has a lower damage\nrate, but a higher\ncritical chance."
		},
		"sonar spell": {
			"name": "Sonar Spell",
			"action": "sonar_spell_state",
			"info": "A basic ranged\nattack."
		}
	}
	return to_json(actions)

#### ITEMS ####
var items = parse_json(get_item_data())

func get_item_data():
	var items = {
		"potion": {
			"name": "Potion",
			"effect": "heal_effect",
			"info": "A potion that\nheals 50 health.",
			"arguments": [50],
			"battle": false
		}
	}
	return to_json(items)

### ITEM EFFECTS ###
func heal_effect(args):
	get_tree().current_scene.sfx.sound("res://Audio/SFX/potion.wav")
	var amount = args[0]
	PStats.stats["health"] = min(PStats.stats["health"] + amount, PStats.stats["maxhealth"])
	if get_tree().current_scene.name == "Battle":
		get_tree().current_scene.find_node("PlayerUnit").flash(Color.green)

### SPRITES ###
var sprites = parse_json(get_sprite_data())

func get_sprite_data():
	var sprites = {
		"res://MainScenes/Battle/Units/Assets/elizabeth/s_battle_elizabeth_ranged.png": {
			"xoffset": 40,
			"yoffset": 8,
			"hitframe": 4
		},
		"res://MainScenes/Battle/Units/Assets/gargoyle/s_battle_gargoyle_ranged.png": {
			"xoffset": -40,
			"yoffset": 0,
			"hitframe": 11
		}
	}
	return to_json(sprites)