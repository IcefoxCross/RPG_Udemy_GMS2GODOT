extends Node2D

class_name Unit

export (Vector2) var sprite_offset = Vector2(0,0)

onready var sprite = $Sprite
onready var anim = $AnimationPlayer
onready var ui = $BattleUnitUI
onready var ray = $RayCast2D

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

var battle
var start_pos

func _ready():
	max_action_meter = 100
	self.action_meter = 0
	item_index = 0
	state = "idle_state"
	ui.visible = true
	start_pos = position
	battle = get_tree().current_scene
	set_physics_process(false)

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
	sprite.scale.x =  -1 if is_enemy else 1
	ray.cast_to.x = 16 * (-1 if is_enemy else 1)
	ray.position.x = 16 * (-1 if is_enemy else 1)
	
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
	#anim.current_animation = "idle"
	anim.play("idle")
	set_physics_process(true)

### ACTIONS ###
func deal_damage(atk, def, critical, modifier):
	var attacker = atk.stats_object
	var defender = def.stats_object
	
	var attack = attacker.stats["attack"]
	var defense = defender.stats["defense"]
	var defending_unit = def
	
	if attacker != null and defender != null:
		var damage = (attack+(attacker.level*3)+(1-defense*.05))*.5
		var total_damage = (damage+(critical*damage*(attacker.stats["critical"]/100)))
		total_damage *= modifier
		
		# Deal damage
		defender.stats["health"] -= round(total_damage)
		print(defender.stats["health"])

func destroy():
	if is_in_group("enemy"):
		queue_free()
		emit_signal("battle_won")

func change_anim(sprite):
	if sprite.texture != sprites[sprite]:
		sprite.texture = sprites[sprite]
		anim.playback_speed = anim_speed[sprite]
		anim.play(sprite)

func _physics_process(delta):
	var dis = draw_health - stats_object.stats["health"]
	if dis > 1:
		self.draw_health = lerp(draw_health, stats_object.stats["health"], .1)
	else:
		self.draw_health = stats_object.stats["health"]
	call(state)

### STATES ###
func idle_state():
	z_index = 0
	if battle.play:
		var action_rate = (stats_object.stats["speed"]+stats_object.level) / 15
		self.action_meter = min(action_meter + action_rate, max_action_meter)
		
		# Action Meter full -> Action State
		if action_meter == max_action_meter:
			state = "action_state"
			battle.play = false
			action_meter = 0

func action_state():
	z_index = 1
	
	if self.is_in_group("enemy"):
		state = "approach_state"
	
	if Input.is_action_just_pressed("action"):
		state = "approach_state"

func approach_state():
	ui.visible = false
	# Set up
	var target_x = start_pos.x + gdata.BATTLE_SPACE * sprite.scale.x
	var speed = 8
	# Move to target
	position.x = gdata.approach(position.x, target_x, speed)
	if position.x == target_x:
		state = "attack_state"

func attack_state():
	var foe = ray.get_collider().get_parent()
	if foe != null and foe.is_in_group("unit"):
		deal_damage(self, foe, gdata.chance(stats_object.stats["critical"]/100), 1)
		state = "return_state"

func return_state():
	var target_x = start_pos.x
	var speed = 8
	position.x = gdata.approach(position.x, target_x, speed)
	if position.x == target_x:
		state = "idle_state"
		ui.visible = true
		battle.play = true

### SETS ###
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