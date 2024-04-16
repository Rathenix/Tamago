extends Node2D

var texts_to_show = []
signal done

func _ready():
	visible = false
	$ContinueIndicator/AnimationPlayer.assigned_animation = "flash"
	$ContinueIndicator/AnimationPlayer.play()

func _input(event):
	if event is InputEventScreenTouch and event.is_pressed():
		next()
	if event is InputEventScreenTouch and !event.is_pressed():
		if not visible: emit_signal("done")

func display_text(texts):
	texts_to_show = texts
	next()
	visible = true

func next():
	if texts_to_show.size() > 0:
		$RichTextLabel.text = "[color=black]" + str(texts_to_show.pop_front()) + "[/color]"
	else:
		$RichTextLabel.text = ""
		visible = false
