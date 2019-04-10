extends Node2D

class_name Unit

export (Vector2) var sprite_offset = Vector2(0,0)

onready var sprite = $Sprite
onready var anim = $AnimationPlayer
onready var ui = $BattleUnitUI
onready var ray = $RayCast2D
onready var shader = $Sprite.material

signal battle_won

var level setget set_level
var _class
var items
var actions
var stats
var draw_health setget set_draw_health

var action_meter setget set_action_meter
var max_action_meter
var item_name
var state

var stats_object = null
var anim_speed = {}
var sprites = {}

var battle
var start_pos
var sprite_start_pos
var attacked
var used_item

func _ready():
	max_action_meter = 100
	self.action_meter = 0
	item_name = null
	state = "idle_state"
	ui.visible = true
	start_pos = position
	battle = get_tree().current_scene
	set_physics_process(false)

func start(_name, _level, is_enemy, idle_speed, attack_speed, hit_speed, range_speed):
	# Stats object
	stats_object = self
	if not is_enemy:
		stats_object = PStats
	# Enemy stats
	if is_enemy:
		stats = PStats.get_stats_from_class(_name)
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
	sprites["use_item"] = load(str("res://MainScenes/Battle/Units/Assets/",_name,"/s_battle_",_name,"_use_item.png"))
	
	anim_speed["idle"] = idle_speed
	anim_speed["approach"] = 0
	anim_speed["attack"] = attack_speed
	anim_speed["return"] = 0
	anim_speed["hit"] = hit_speed
	anim_speed["ranged"] = range_speed
	anim_speed["use_item"] = 1
	
	change_anim("idle")
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
		#print(defender.stats["health"])

func destroy():
	if is_in_group("enemy"):
		# Add EXP
		PStats.stats["experience"] += min(1+level/2, 1) * stats_object.stats["experience"]
		queue_free()
		emit_signal("battle_won")

func change_anim(image):
	if sprite.texture != sprites[image]:
		sprite.texture = sprites[image]
		anim.playback_speed = anim_speed[image]
		anim.play(image)
		set_pivot("bottom_center")

func _physics_process(delta):
	var dis = draw_health - stats_object.stats["health"]
	if dis > 1:
		self.draw_health = lerp(draw_health, stats_object.stats["health"], .1)
	else:
		self.draw_health = stats_object.stats["health"]
	call(state)

func flash(color, duration = 1):
	var c = color
	var not_white = color != Color.white
	c.a = 0
	if not_white:
		sprite.modulate = color
	shader.set_shader_param("flash", true)
	shader.set_shader_param("flash_color", c)
	yield(get_tree().create_timer(0.05),"timeout")
#	shader.set_shader_param("flash_color", Color(0))
	var tween = Tween.new()
	var tweensprite
	tween.interpolate_property(shader, "shader_param/flash_color",c,Color(0,0,0,0),duration,Tween.TRANS_QUAD,Tween.EASE_OUT)
	add_child(tween)
	tween.start()
	if not_white:
		tweensprite = Tween.new()
		tween.interpolate_property(sprite, "modulate",modulate,Color.white,1,Tween.TRANS_QUAD,Tween.EASE_OUT)
	yield(tween,"tween_completed")
	shader.set_shader_param("flash", false)
	tween.queue_free()
	if not_white:
		tweensprite.queue_free()

### STATES ###
func idle_state():
	change_anim("idle")
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
	change_anim("idle")
	z_index = 1
	
	if self.is_in_group("enemy"):
		state = "approach_state"
	
#	if Input.is_action_just_pressed("action"):
#		state = "approach_state"

func approach_state():
	ui.visible = false
	# Set up
	var target_x = start_pos.x + GData.BATTLE_SPACE * sprite.scale.x
	change_anim("approach")
	var sprite_frames = sprite.vframes * sprite.hframes
	var speed = min(14, 38/sprite_frames)
	# Anim speed
	var frames = GData.get_frames(target_x, start_pos.x, speed)
	anim.playback_speed = GData.get_image_speed_from_frames(frames, sprite_frames)
	# Move to target
	position.x = GData.approach(position.x, target_x, speed)
	if position.x == target_x:
		state = "attack_state"
		attacked = false

func attack_state():
	change_anim("attack")
	if sprite.frame == 1 and not attacked:
		var foe = ray.get_collider()
		if foe != null and foe.get_parent().is_in_group("unit"):
			deal_damage(self, foe.get_parent(), GData.chance(stats_object.stats["critical"]/100), 1)
			foe.get_parent().flash(Color.white, 0.5)
			foe.get_parent().state = "hit_state"
			attacked = true
	if not anim.is_playing():
		state = "return_state"
		attacked = false

func return_state():
	var target_x = start_pos.x
	change_anim("return")
	var sprite_frames = sprite.vframes * sprite.hframes
	var speed = 3
	# Anim speed
	var frames = GData.get_frames(target_x, start_pos.x+GData.BATTLE_SPACE*sprite.scale.x, speed)
	anim.playback_speed = GData.get_image_speed_from_frames(frames, sprite_frames)
	# Move back
	speed = 5
	position.x = GData.approach(position.x, target_x, speed)
	if position.x == target_x:
		state = "wait_state"
		ui.visible = true
		#battle.play = true

func use_item_state():
	if is_in_group("enemy"):
		state = "wait_state"
		return
	change_anim("use_item")
	if sprite.frame == 4 and not used_item:
		PStats.use_item(item_name)
		used_item = true

func wait_state():
	change_anim("idle")
	z_index = 0

func hit_state():
	change_anim("hit")
	var frames = (anim.current_animation_position / anim.current_animation_length) * PI
	sprite.position.x = sprite_start_pos.x - sin(frames) * 32 * sprite.scale.x
	
	if (sprite.position.x - sprite_start_pos.x > 24 and stats_object.stats["health"] <= 0):
		state = "death_state"
		anim.stop()

func death_state():
	if sprite.modulate.a > 0:
		sprite.modulate.a -= 0.02
	else:
		destroy()

### SETS ###
func set_pivot(pivot):
	match pivot:
		"bottom_center":
			sprite.position = Vector2(0 + sprite_offset.x, 0 - (sprite.texture.get_height()/2) + sprite_offset.y)
	sprite_start_pos = sprite.position

func set_level(value):
	level = value
	ui.draw_level()

func set_draw_health(value):
	draw_health = value
	ui.draw_health()

func set_action_meter(value):
	action_meter = value
	ui.draw_action()

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"use_item":
			state = "idle_state"
			battle.play = true
			used_item = false
		"hit":
			state = "wait_state"
			sprite.position.x = sprite_start_pos.x
