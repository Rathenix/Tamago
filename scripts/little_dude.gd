extends Node

const MAX_ENERGY = 5
const ENERGY_ACCRUAL_TIMEOUT = 60

var dude_name = "Dude Not Found"
var dude_sprite = "res://icon.svg"
var dude_birthdate = 0
var dude_size = 0
var dude_energy = 0
var dude_loyalty = 0
var dude_mood = 0
var dude_wellness = 0

var attack = 0
var defense = 0
var mind = 0
var spirit = 0
var skill = 0
var speed = 0
var current_hp = 0
var max_hp = 0

var time_of_last_energy_accrued = 0
signal dude_updated

func _ready():
	pass

func _process(_delta):
	accrueEnergy()

func hatch():
	dude_name = "Little Dude"
	dude_sprite = "res://images/littleDude.png"
	dude_birthdate = int(Time.get_unix_time_from_system()) # UTC
	dude_size = DudeManager.random.randi_range(10, 30)
	dude_energy = 3
	dude_loyalty = 1
	dude_mood = 1
	dude_wellness = 1
	attack = DudeManager.random.randi_range(1, 5)
	defense = DudeManager.random.randi_range(1, 5)
	mind = DudeManager.random.randi_range(1, 5)
	spirit = DudeManager.random.randi_range(1, 5)
	skill = DudeManager.random.randi_range(1, 5)
	speed = DudeManager.random.randi_range(1, 5)
	max_hp = DudeManager.random.randi_range(8, 15)
	current_hp = max_hp
	time_of_last_energy_accrued = dude_birthdate

func save():
	return {
	"dude_name" : dude_name,
	"dude_sprite": dude_sprite,
	"dude_birthdate" : dude_birthdate,
	"dude_size" : dude_size,
	"dude_energy" : dude_energy,
	"dude_loyalty" : dude_loyalty,
	"dude_mood" : dude_mood,
	"dude_wellness" : dude_wellness,
	"attack" : attack,
	"defense" : defense,
	"mind" : mind, 
	"spirit" : spirit,
	"skill" : skill,
	"speed" : speed,
	"current_hp" : current_hp,
	"max_hp" : max_hp,
	"time_of_last_energy_accrued" : time_of_last_energy_accrued
	}

func accrueEnergy():
	var energy_accrual = (int(Time.get_unix_time_from_system()) - int(time_of_last_energy_accrued)) / ENERGY_ACCRUAL_TIMEOUT
	if energy_accrual > 0:
		print("time to accrue " + str(energy_accrual) + " energy")
		time_of_last_energy_accrued = int(Time.get_unix_time_from_system())
		dude_energy = clamp(dude_energy + energy_accrual, 0, MAX_ENERGY)
		emit_signal("dude_updated")

func train(stats_to_train):
	var feedback = []
	print(stats_to_train)
	for stat in stats_to_train:
		# check energy
		if dude_energy <= 0:
			feedback.append(dude_name + " passed out from exhaustion")
			dude_energy = 0
			dude_wellness -= 1
			dude_loyalty -= 1
			dude_mood -= 1
			break
		else:
			dude_energy -= 1
			# figure out which stat this is
			var current_value
			match stat:
				"HP": 
					feedback.append("Training HP...")
					current_value = max_hp
				"Attack": 
					feedback.append("Training Attack...")
					current_value = attack
				"Defense": 
					feedback.append("Training Defense...")
					current_value = defense
				"Mind": 
					feedback.append("Training Mind...")
					current_value = mind
				"Spirit": 
					feedback.append("Training Spirit...")
					current_value = spirit
				"Skill": 
					feedback.append("Training Skill...")
					current_value = skill
				"Speed": 
					feedback.append("Training Speed...")
					current_value = speed
			# get level of effort based on loyalty, mood, and wellness
			var random_chance = DudeManager.random.randi_range(-3, 6)
			var effort = dude_wellness + dude_mood + dude_loyalty + random_chance
			if effort <= 0:
				feedback.append(dude_name + " didn't even try")
			elif effort >= 1 and effort <= 2:
				feedback.append(dude_name + " phoned it in")
			elif effort >= 3 and effort <= 4:
				feedback.append(dude_name + " gave it a shot")
			elif effort >= 5:
				feedback.append(dude_name + " tried their best")
			# attempt to raise the stat based on effort and current value
			var attempt = effort + current_value
			feedback.append("Total attempt = " + str(attempt) + "/10")
			var success = attempt >= 10
			# increase stat by a random amount based on success and training
			# update dude's feelings based on success and feedback
			if !success:
				feedback.append(dude_name + " failed the training")
				dude_mood -= 1
			else:
				var increase = DudeManager.random.randi_range(1, 3)
				match stat:
					"HP": 
						max_hp += increase
					"Attack": 
						attack += increase
					"Defense": 
						defense += increase
					"Mind": 
						mind += increase
					"Spirit": 
						spirit += increase
					"Skill": 
						skill += increase
					"Speed": 
						speed += increase
				feedback.append(dude_name + " did it! Stat went up by " + str(increase) + " and is now " + str(current_value + increase))
				dude_mood += 1
			# ask user for feedback
		feedback.append("Praise them?") # scale of scold to praise
	emit_signal("dude_updated")
	print(feedback)
	return feedback
