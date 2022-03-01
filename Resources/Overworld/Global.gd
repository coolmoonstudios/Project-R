extends Node2D

var disable_light = true

var item_data : Dictionary
onready var root = get_tree().get_root()

var rabbit = preload("res://Resources/Rabbit/WildRabbit.tscn")

var path = OS.get_data_dir() + "/CoolMoon Studios/ProjectR/"
var last_pos

var vegetables = [
	"Carrot"
	]

var scenes = [
	"World",
	"HouseInside"
]

func _ready():
	load_files("res://Data/")
	for each in scenes:
		ResourceSaver.save("user://"+str(each)+".tscn", load("res://Scenes/"+str(each)+".tscn"))
	#item_data = load_data("item_data.json")


func _process(_delta):
	if Input.is_action_just_released("debug"):
		root.get_node("/root/SceneManager/CurrentScene/World/YSort/WaterTrough/Level").visible = !root.get_node("/root/SceneManager/CurrentScene/World/YSort/WaterTrough/Level").visible 
		root.get_node("/root/SceneManager/CurrentScene/World/YSort/FoodTrough/Level").visible = !root.get_node("/root/SceneManager/CurrentScene/World/YSort/FoodTrough/Level").visible 


func load_data(file):
	var file_path = "res://Data/" + file
	var json_data
	var file_data = File.new()
	file_data.open(file_path, File.READ)
	json_data = JSON.parse(file_data.get_as_text())
	file_data.close()
	return json_data.result	


func load_files(path):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				
				var file_data = load_data(file_name)
				
				for key in file_data:
					item_data[key] = file_data[key]
				
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")


func file_check(scene_name):
	var file_check = File.new()
	if file_check.file_exists("user://" + str(scene_name) + ".tscn") == true:
		print("Using existing")
		return "user://"+ scene_name +".tscn"
	else:
		print("Using new")
		#return "res://Scenes/"+ scene_name +".tscn"


func set_camera_limits(tilemap):
	var map_limits = tilemap.get_used_rect()
	var map_cellsize = tilemap.cell_size
	var camera = get_parent().get_node("/root/SceneManager/Camera2D")
	
	camera.limit_left = map_limits.position.x * map_cellsize.x
	camera.limit_right = map_limits.end.x * map_cellsize.x
	camera.limit_top = map_limits.position.y * map_cellsize.y
	camera.limit_bottom = map_limits.end.y * map_cellsize.y
