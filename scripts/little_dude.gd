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
signal energy_accrued

func _ready():
	pass

func _process(_delta):
	var energy_accrual = (int(Time.get_unix_time_from_system()) - int(time_of_last_energy_accrued)) / ENERGY_ACCRUAL_TIMEOUT
	if energy_accrual > 0:
		print("time to accrue " + str(energy_accrual) + " energy")
		time_of_last_energy_accrued = int(Time.get_unix_time_from_system())
		dude_energy = clamp(dude_energy + energy_accrual, 0, MAX_ENERGY)
		emit_signal("energy_accrued")

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
