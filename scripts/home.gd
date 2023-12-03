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
	dude.energy_accrued.connect(_on_dude_energy_accrued)
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
				stats_to_train.append(node)
	for stat in stats_to_train:
		# check energy
		if dude.dude_energy <= 0:
			print(dude.dude_name + " passed out from exhaustion")
			dude.dude_energy = 0
			dude.dude_wellness -= 1
			dude.dude_loyalty -= 1
			dude.dude_mood -= 1
			break
		else:
			dude.dude_energy -= 1
			# figure out which stat this is
			var current_value
			match stat.text:
				"HP": 
					print("Training HP...")
					current_value = dude.max_hp
				"Attack": 
					print("Training Attack...")
					current_value = dude.attack
				"Defense": 
					print("Training Defense...")
					current_value = dude.defense
				"Mind": 
					print("Training Mind...")
					current_value = dude.mind
				"Spirit": 
					print("Training Spirit...")
					current_value = dude.spirit
				"Skill": 
					print("Training Skill...")
					current_value = dude.skill
				"Speed": 
					print("Training Speed...")
					current_value = dude.speed
			# get level of effort based on loyalty, mood, and wellness
			var random_chance = DudeManager.random.randi_range(-3, 6)
			var effort = dude.dude_wellness + dude.dude_mood + dude.dude_loyalty + random_chance
			if effort <= 0:
				print(dude.dude_name + " didn't even try")
			elif effort >= 1 and effort <= 2:
				print(dude.dude_name + " phoned it in")
			elif effort >= 3 and effort <= 4:
				print(dude.dude_name + " gave it a shot")
			elif effort >= 5:
				print(dude.dude_name + " tried their best")
			# attempt to raise the stat based on effort and current value
			var attempt = effort + current_value
			print("Total attempt = " + str(attempt) + "/10")
			var success = attempt >= 10
			# increase stat by a random amount based on success and training
			# update dude's feelings based on success and feedback
			if !success:
				print(dude.dude_name + " failed the training")
				dude.dude_mood -= 1
			else:
				var increase = DudeManager.random.randi_range(1, 3)
				match stat.text:
					"HP": 
						dude.max_hp += increase
					"Attack": 
						dude.attack += increase
					"Defense": 
						dude.defense += increase
					"Mind": 
						dude.mind += increase
					"Spirit": 
						dude.spirit += increase
					"Skill": 
						dude.skill += increase
					"Speed": 
						dude.speed += increase
				print(dude.dude_name + " did it! Stat went up by " + str(increase) + " and is now " + str(current_value + increase))
				dude.dude_mood += 1
			# ask user for feedback
			print("Praise them?") # scale of scold to praise
	setup_dude_info()

func no_current_window():
	return !battle_stats_window.visible \
		and !training_window.visible

func _on_battle_button_pressed():
	if no_current_window():
		battle_stats_window.visible = true

func _on_training_button_pressed():
	if no_current_window():
		training_window.visible = true

func _on_quests_button_pressed():
	if no_current_window():
		pass

func _on_games_button_pressed():
	if no_current_window():
		pass

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

func _on_dude_energy_accrued():
	setup_dude_info()
