extends KinematicBody2D

export(String) var scene_name = ""
var is_inside = false
var scene = ""

func _process(_delta):
	if is_inside == true and Input.is_action_just_released("interact"):
		scene = Global.file_check(scene_name)
		
		get_node(NodePath("/root/SceneManager")).trans_to_scene(scene)
		

func _on_InteractArea_area_entered(_area):
	is_inside = true


func _on_InteractArea_area_exited(_area):
	is_inside = false
