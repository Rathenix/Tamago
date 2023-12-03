extends Node

var config = ConfigFile.new()
var config_path = "user://player_data.cfg"
var save_path = "user://save_data.sav"

func _ready():
	get_tree().set_auto_accept_quit(false)
	if config.load(config_path) != OK:
		print("loading player config NOT ok")
	load_dudes()

func _process(_delta):
	if Input.is_action_just_pressed("save"):
		save_dudes() 

func get_config_value(section, property):
	return config.get_value(section, property)

func save_config_value(section, property, value):
	config.set_value(section, property, value)

func save_dudes():
	var save_data = FileAccess.open(save_path, FileAccess.WRITE)
	var dudes_to_save = DudeManager.get_all_dudes_to_save()
	for dude in dudes_to_save:
		save_data.store_line(dude)
	print("dudes saved")

func load_dudes():
	if not FileAccess.file_exists(save_path):
		print("save file not found")
		DudeManager.add_new_dude()
		return
	var save_data = FileAccess.open(save_path, FileAccess.READ)
	var dudes_data = []
	while save_data.get_position() < save_data.get_length():
		var dude_json = save_data.get_line()
		var json = JSON.new()
		var parse_result = json.parse(dude_json)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", dude_json, " at line ", json.get_error_line())
			continue
		dudes_data.append(json.get_data())
	DudeManager.load_dudes(dudes_data)

func save_config_to_disk():
	config.save(config_path)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST: # wont work on mobile
		save_dudes()
		# save_config_to_disk()
		get_tree().quit() # default behavior
