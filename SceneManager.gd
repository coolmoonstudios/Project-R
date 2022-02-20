extends Node2D

onready var anim_player = $ScreenTransition/AnimationPlayer

var last_scene = null
var next_scene = null


func _ready():
	$ScreenTransition/ColorRect.visible = true


func trans_to_scene(new_scene: String):
	next_scene = new_scene
	anim_player.play("FadeToBlack")


func finish_fading():
	last_scene = $CurrentScene.get_child(0).name
	
	Global.disable_light = !Global.disable_light
	
	var file_path = Global.file_check(last_scene)
	var scene_node = PackedScene.new()
	print(file_path)
	scene_node.pack($CurrentScene.get_child(0))
	ResourceSaver.save(file_path, scene_node)
	
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(load(next_scene).instance())
	anim_player.play("FadeToNormal")
