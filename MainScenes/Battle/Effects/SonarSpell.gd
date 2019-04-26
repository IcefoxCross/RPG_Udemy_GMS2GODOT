extends "res://MainScenes/Battle/Effects/Projectile.gd"

onready var anim = $AnimationPlayer

var speed = 3
var attack = false

func _ready():
	._ready()
	sfx.play()

func _process(delta):
	._process(delta)
	position.x += speed * creator.sprite.scale.x
	if sprite.frame == 5 and not attack:
		attack = true
		speed = 0
		target.flash(Color.azure, 0.25)
		creator.deal_damage(creator, target, GData.chance(creator.stats_object.stats["critical"]/100),1)
		target.state = "hit_state"
		get_tree().current_scene.camera.camera_screenshake(4,.2)

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("finished")
	queue_free()
