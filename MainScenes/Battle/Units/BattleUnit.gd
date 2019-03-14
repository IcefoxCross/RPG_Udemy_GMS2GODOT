extends Node2D

onready var sprite = $Sprite
onready var anim = $AnimationPlayer

var level
var _class
var items
var actions
var stats
var draw_health

var action_meter
var max_action_meter
var item_index
var state

var stats_object
var anim_speed = {}
var sprites = {}

func _ready():
	action_meter = 0
	max_action_meter = 100
	item_index = 0
	state = null

func start(_name, _level, is_enemy, idle_speed, attack_speed, hit_speed, range_speed):
	level = _level
	# Stats object
	stats_object = self
	if not is_enemy:
		stats_object = Stats
	# Enemy stats
	if is_enemy:
		stats = Stats.get_stats_from_class(_name)
		draw_health = stats["health"]
	sprite.flip_h = is_enemy
	
	sprites["idle"] = load(str("res://MainScenes/Battle/Units/Assets/",_name,"/s_battle_",_name,"_idle.png"))
	sprites["approach"] = load(str("res://MainScenes/Battle/Units/Assets/",_name,"/s_battle_",_name,"_approach.png"))
	sprites["attack"] = load(str("res://MainScenes/Battle/Units/Assets/",_name,"/s_battle_",_name,"_attack.png"))
	sprites["return"] = load(str("res://MainScenes/Battle/Units/Assets/",_name,"/s_battle_",_name,"_return.png"))
	sprites["hit"] = load(str("res://MainScenes/Battle/Units/Assets/",_name,"/s_battle_",_name,"_hit.png"))
	sprites["ranged"] = load(str("res://MainScenes/Battle/Units/Assets/",_name,"/s_battle_",_name,"_ranged.png"))
	
	anim_speed["idle"] = idle_speed
	anim_speed["approach"] = 0
	anim_speed["attack"] = attack_speed
	anim_speed["return"] = 0
	anim_speed["hit"] = hit_speed
	anim_speed["ranged"] = range_speed
	
	anim.playback_speed = anim_speed["idle"]
	sprite.texture = sprites["idle"]
	anim.current_animation = "idle"
	anim.play("idle")
