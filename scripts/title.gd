extends Node2D

func _ready():
	$RichTextLabel2/AnimationPlayer.assigned_animation = "flash"
	$RichTextLabel2/AnimationPlayer.play()

func _input(event):
	if event is InputEventScreenTouch and event.is_pressed():
		SceneManager.goto_scene("res://Scenes/home.tscn")
