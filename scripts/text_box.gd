extends Node2D

var texts_to_show = []
signal done
signal prompt_pressed(value)
var prompt = false
var left_value = "left"
var right_value = "right"

func _ready():
	visible = false
	$ContinueIndicator/AnimationPlayer.assigned_animation = "flash"
	$ContinueIndicator/AnimationPlayer.play()
	$LeftButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$RightButton.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _input(event):
	if !prompt:
		if event is InputEventScreenTouch and event.is_pressed():
			next()
	if event is InputEventScreenTouch and !event.is_pressed():
		if not visible: emit_signal("done")
		elif prompt: emit_signal("done")

func display_text(texts):
	texts_to_show = texts
	next()
	visible = true

func next():
	if texts_to_show.size() > 0:
		var text = texts_to_show.pop_front()
		if text.begins_with("{"):
			prompt = true
			$ContinueIndicator.visible = false
			$LeftButton.visible = true
			$RightButton.visible = true
			$LeftButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
			$RightButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
			var prompt_json = JSON.parse_string(text)
			$RichTextLabel.text = "[color=black]" + str(prompt_json.prompt_text) + "[/color]"
			$LeftButton.text = prompt_json.left_button.text
			left_value = prompt_json.left_button.value
			$RightButton.text = prompt_json.right_button.text
			right_value = prompt_json.right_button.value
		else:
			prompt = false
			$RichTextLabel.text = "[color=black]" + str(text) + "[/color]"
	else:
		$RichTextLabel.text = ""
		visible = false

func _on_left_button_pressed():
	emit_signal("prompt_pressed", left_value)
	$ContinueIndicator.visible = true
	$LeftButton.visible = false
	$RightButton.visible = false
	$LeftButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$RightButton.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_right_button_pressed():
	emit_signal("prompt_pressed", right_value)
	$ContinueIndicator.visible = true
	$LeftButton.visible = false
	$RightButton.visible = false
	$LeftButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$RightButton.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_done():
	$LeftButton.mouse_filter = Control.MOUSE_FILTER_STOP
	$RightButton.mouse_filter = Control.MOUSE_FILTER_STOP
