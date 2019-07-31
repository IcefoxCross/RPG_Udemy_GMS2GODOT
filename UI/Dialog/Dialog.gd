extends CanvasLayer

"""
Dialog
	Node to start and display a Dialog on the screen, with as many pages of text as you want, as long as it fits the dialog window.
	When it finishes going through all the lines, it emits the Finished signal.
	You can change the speed at which the text scrolls on the window, and even set special characters to stop the scrolling mid sentence.
	With the function init() you set up what lines of text to display and a portrait image, then it starts processing each text line.
"""

onready var box = $Control/DialogBox
onready var text_visible = $Control/DialogBox/RichTextLabel
onready var portrait_frame = $Control/PortraitFrame
onready var portrait = $Control/PortraitFrame/Portrait
onready var timer = $Control/DialogBox/Timer
onready var sound = $SFX

signal finished

# CHAR LIMIT (FONT 9) = 156
var text = ["Test. dialog", "Test? dialog 2."]
var char_stopper = [".", "?", "!"]
var text_page = 0
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
	
	#init(text, load("res://UI/Assets/Dialog/s_default_portrait_0.png"))

func init(dialog, p_sprite, font_size = 9, text_speed = 0.05):
	text = dialog
	portrait.texture = p_sprite
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
	emit_signal("finished")

func _input(event):
	if event.is_action_pressed("action"):
		if text_visible.visible_characters > text_visible.get_total_character_count():
			if text_page < text.size()-1:
				text_page += 1
				start()
			else:
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

