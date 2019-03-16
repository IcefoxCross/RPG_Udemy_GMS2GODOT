extends Node2D

export (Vector2) var sprite_offset = Vector2(0,0)

onready var sprite = $Sprite
onready var anim = $AnimationPlayer
onready var ui = $BattleUnitUI

signal battle_won

var level setget set_level
var _class
var items
var actions
var stats
var draw_health setget set_draw_health

var action_meter setget set_action_meter
var max_action_meter
var item_index
var state

var stats_object
var anim_speed = {}
var sprites = {}

func _ready():
	max_action_meter = 100
	self.action_meter = 0
	item_index = 0
	state = null

func start(_name, _level, is_enemy, idle_speed, attack_speed, hit_speed, range_speed):
	# Stats object
	stats_object = self
	if not is_enemy:
		stats_object = Stats
	# Enemy stats
	if is_enemy:
		stats = Stats.get_stats_from_class(_name)
	self.level = _level
	self.draw_health = stats_object.stats["health"]
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
	set_pivot("bottom_center")
	anim.current_animation = "idle"
	anim.play("idle")

func destroy():
	if is_in_group("enemy"):
		queue_free()
		emit_signal("battle_won")

func set_pivot(pivot):
	match pivot:
		"bottom_center":
			sprite.position = Vector2(0 + sprite_offset.x, 0 - (sprite.texture.get_height()/2) + sprite_offset.y)

func set_level(value):
	level = value
	ui.draw_level()

func set_draw_health(value):
	draw_health = value
	ui.draw_health()

func set_action_meter(value):
	action_meter = value
	ui.draw_action()