extends CanvasLayer

onready var box = $Control/DialogBox
onready var text_visible = $Control/DialogBox/RichTextLabel
onready var portrait_frame = $Control/PortraitFrame
onready var portrait = $Control/PortraitFrame/Portrait
onready var timer = $Control/DialogBox/Timer

# CHAR LIMIT (FONT 9) = 156
var text = ["Test. dialog", "Test? dialog 2."]
var char_stopper = [".", "?", "!"]
var text_page = 0
var cutscene = null
var text_speed = .05
var pause_speed = .5

var view = Vector2()
var pos = Vector2()
var portrait_pos = Vector2()
var portrait_size = Vector2(62,61)

func _ready():
	#visible = false
	view = Vector2(ProjectSettings.get_setting("display/window/size/width"),
			ProjectSettings.get_setting("display/window/size/height"))
	pos = Vector2(28, (view.y - box.rect_size.y) - 4)
	portrait_pos = Vector2((view.x - portrait_frame.rect_size.x) - 31,
	(view.y - portrait_frame.rect_size.y) - 4)
	set_process_input(false)
	
	box.rect_position = pos
	portrait_frame.rect_position = portrait_pos
	
	init(text, "res://UI/Assets/Dialog/s_default_portrait_0.png")

func init(dialog, p_sprite, font_size = 9, text_speed = 0.05):
	text = dialog
	portrait.texture = load(p_sprite)
	portrait.rect_size = portrait_size
	text_page = 0
	text_visible.get("custom_fonts/normal_font").size = font_size
	timer.wait_time = text_speed
	start()

func start():
	text_visible.text = text[text_page]
	text_visible.visible_characters = 0
	set_process_input(true)
	timer.start()

func end():
	queue_free()
#	$Control.visible = false
#	set_process_input(false)
#	timer.stop()

func _input(event):
	if event.is_action_pressed("action"):
		if text_visible.visible_characters > text_visible.get_total_character_count():
			if text_page < text.size()-1:
				text_page += 1
				start()
			else:
				if cutscene != null:
					cutscene.action += 1
				end()
		elif text_visible.text[text_visible.visible_characters-1] in char_stopper:
			timer.start()
		else:
			text_visible.visible_characters = text_visible.get_total_character_count()
		get_tree().set_input_as_handled()

func _on_Timer_timeout():
	text_visible.visible_characters += 1
	if timer.wait_time == pause_speed:
		timer.wait_time = text_speed
	if text_visible.visible_characters < text_visible.get_total_character_count():
		if text_visible.text[text_visible.visible_characters-1] in char_stopper and text_visible.visible_characters != text_visible.get_total_character_count():
			timer.wait_time = pause_speed

