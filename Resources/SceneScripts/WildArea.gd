extends Node2D


func _ready():
	Global.set_camera_limits($Navigation2D/Ground)
	save_rabbits()


func save_rabbits():
	get_tree().call_group("WildArea Rabbits", "save_data")

