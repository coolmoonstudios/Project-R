extends Node2D

var water_level = 20
var food_level = 10


func _ready():
	Global.set_camera_limits($Navigation2D/Ground)
