extends "res://MainScenes/Battle/Effects/Projectile.gd"

onready var anim = $AnimationPlayer

var attack = false

func _ready():
	._ready()

func _process(delta):
	._process(delta)
	if sprite.frame == 2 and not sfx.playing:
		sfx.play()
	
	if sprite.frame == 7 and not attack:
		attack = true
		get_tree().current_scene.camera.camera_screenshake(8,.2)
		
		var critical = GData.chance(.7)
		creator.deal_damage(creator, target, critical, 1+(critical*0.25))
		target.flash(Color.red, 0.25)
		target.state = "hit_state"


func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("finished")
	queue_free()
