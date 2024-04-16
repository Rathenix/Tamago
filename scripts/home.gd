extends Node2D

var dude
var sprite_animation_player

var battle_stats_window
var training_window
var training_cost = 0

func _ready():
	sprite_animation_player = $Sprite/AnimationPlayer
	sprite_animation_player.assigned_animation = "idle"
	sprite_animation_player.play()
	dude = DudeManager.get_active_dude()
	dude.dude_updated.connect(_on_dude_updated)
	setup_dude_info()
	battle_stats_window = $BattleStats
	battle_stats_window.visible = false
	training_window = $Training
	training_window.visible = false

func _input(event):
	if event is InputEventScreenTouch and event.is_pressed():
		# print(event)
		pass

func setup_dude_info():
	$Sprite.texture = load(dude.dude_sprite)
	$NameLabel.text = "[color=black]" + dude.dude_name + "[/color]"
	$BirthdayLabel.text = "[color=black]Born: " + Time.get_datetime_string_from_unix_time(dude.dude_birthdate) + "[/color]"
	$SizeLabel.text = "[color=black]" + str(dude.dude_size) + " bytes[/color]"
	$EnergyLabel.text = "[color=black]Energy: " + str(dude.dude_energy) + "/5[/color]"
	$LoyaltyLabel.text = "[color=black]Loyalty: " + str(dude.dude_loyalty) + " (Stranger)[/color]"
	$MoodLabel.text = "[color=black]Mood: " + str(dude.dude_mood) + " (Neutral)[/color]"
	$WellnessLabel.text = "[color=black]Wellness: " + str(dude.dude_wellness) + " (Fine)[/color]"
	
	$BattleStats/HpLabel.text = "[color=black]HP: " + str(dude.current_hp) + "/" + str(dude.max_hp) + "[/color]"
	$BattleStats/AttackLabel.text = "[color=black]Attack: " + str(dude.attack) + "[/color]"
	$BattleStats/DefenseLabel.text = "[color=black]Defense: " + str(dude.defense) + "[/color]"
	$BattleStats/MindLabel.text = "[color=black]Mind: " + str(dude.mind) + "[/color]"
	$BattleStats/SpiritLabel.text = "[color=black]Spirit: " + str(dude.spirit) + "[/color]"
	$BattleStats/SkillLabel.text = "[color=black]Skill: " + str(dude.skill) + "[/color]"
	$BattleStats/SpeedLabel.text = "[color=black]Speed: " + str(dude.speed) + "[/color]"

func update_cost_label():
	var checked_count = 0
	for node in $Training.get_children():
		if node is CheckBox:
			if node.button_pressed:
				checked_count += 1
	var color = "white" if checked_count <= dude.dude_energy else "red"
	$Training/CostLabel.text = "[color=" + color + "]This will cost " + str(checked_count) + " Energy[/color]"

func train():
	var stats_to_train = []
	for node in $Training.get_children():
		if node is CheckBox:
			if node.button_pressed:
				stats_to_train.append(node.text)
	if stats_to_train.size() > 0:
		_on_close_training_button_pressed()
		display_text(dude.train(stats_to_train))

func no_current_window():
	return !battle_stats_window.visible \
		and !training_window.visible

func display_text(texts):
	$BattleButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$TrainingButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$QuestsButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$GamesButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$TextBox.display_text(texts)

func _on_battle_button_pressed():
	if no_current_window():
		battle_stats_window.visible = true
	elif battle_stats_window.visible:
		battle_stats_window.visible = false

func _on_training_button_pressed():
	if no_current_window():
		training_window.visible = true
	elif training_window.visible:
		_on_close_training_button_pressed()

func _on_quests_button_pressed():
	if no_current_window():
		display_text(["Go on a quest", "Or don't. I'm not the boss of you"])

func _on_games_button_pressed():
	if no_current_window():
		display_text(["And this is where I would put my mini-game collection", "IF I HAD ONE!"])

func _on_close_battle_stats_button_pressed():
	battle_stats_window.visible = false

func _on_close_training_button_pressed():
	training_window.visible = false
	for node in $Training.get_children():
		if node is CheckBox:
			node.button_pressed = false
	$Training/CostLabel.text = "[color=white]This will cost 0 Energy[/color]"

func _on_train_hp_check_box_toggled(_toggled_on):
	update_cost_label()

func _on_train_attack_check_box_toggled(_toggled_on):
	update_cost_label()

func _on_train_defense_check_box_toggled(_toggled_on):
	update_cost_label()

func _on_train_mind_check_box_toggled(_toggled_on):
	update_cost_label()

func _on_train_spirit_check_box_toggled(_toggled_on):
	update_cost_label()

func _on_train_skill_check_box_toggled(_toggled_on):
	update_cost_label()

func _on_train_speed_check_box_toggled(_toggled_on):
	update_cost_label()

func _on_start_taining_button_pressed():
	train()

func _on_dude_updated():
	setup_dude_info()

func _on_text_box_done():
	$BattleButton.mouse_filter = Control.MOUSE_FILTER_STOP
	$TrainingButton.mouse_filter = Control.MOUSE_FILTER_STOP
	$QuestsButton.mouse_filter = Control.MOUSE_FILTER_STOP
	$GamesButton.mouse_filter = Control.MOUSE_FILTER_STOP
