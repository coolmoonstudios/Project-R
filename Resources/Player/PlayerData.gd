extends Node

onready var cycle = get_node(NodePath("/root/SceneManager/CanvasModulate"))

# day/night stuff
var time = 0
var day = 1
var season = "Spring"

# stats
var username = "Player"
var health = 100
var energy = 100
var action = 1000

# settings
var settings_clock = false
var first_boot = true


func reset_values():
	time = 0
	day = 1
	
	username = "Player"
	health = 100
	energy = 100
	action = 1000
	
	settings_clock = false
	first_boot = true


func save_data():
	var data_dict = {
		"username" : username,
		"health" : health,
		"energy" : energy,
		"day" : day
	}
	
	print(data_dict)
	return data_dict


func save_game():
	var dict = null
	var file_name = ""
	
	dict = save_data()
	file_name = username + ".save"
	
	var save_game  = File.new()
	save_game.open("user://" + file_name, File.WRITE)
	
	for data in dict:
		var info = to_json(dict[data])
		save_game.store_line(info)
	
	save_game.close()


func parse_mdata(save):
	var line = parse_json(save.get_line())
	print(line)
	return line


func load_game():
	username = "Player"
	var file_name = "user://" + username + ".save"
	var save_game = File.new()
	
	if not save_game.file_exists(file_name):
		return # Error! We don't have a save to load.

	save_game.open(file_name, File.READ)

	self.username = parse_mdata(save_game)
	self.health = parse_mdata(save_game)
	self.energy = parse_mdata(save_game)
	self.day = parse_mdata(save_game)
	
	cycle.reset_data()
	
	save_game.close()
