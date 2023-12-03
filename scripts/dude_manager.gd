extends Node

var random = RandomNumberGenerator.new()
var dude_path = "res://scenes/little_dude.tscn"

func _ready():
	pass

func add_new_dude():
	var new_dude = load(dude_path).instantiate()
	new_dude.call("hatch")
	add_child(new_dude)

func add_dude(dude_data):
	var new_dude = load(dude_path).instantiate()
	for i in dude_data.keys():
		new_dude.set(i, dude_data[i])
	add_child(new_dude)

func load_dudes(dudes_data):
	for d in get_all_dudes():
		d.queue_free() # get rid of existing dudes to avoid duplicates
	for dude_data in dudes_data:
		add_dude(dude_data)

func get_all_dudes_to_save():
	var dudes_to_save = []
	for dude in get_all_dudes():
		var dude_data = dude.call("save")
		var dude_json = JSON.stringify(dude_data)
		dudes_to_save.append(dude_json)
	return dudes_to_save

func get_all_dudes():
	return get_tree().get_nodes_in_group("Dude")

func get_active_dude():
	var all_dudes = get_all_dudes()
	if all_dudes.size() <= 0:
		print("no dudes!")
		return
	return get_all_dudes()[0]
