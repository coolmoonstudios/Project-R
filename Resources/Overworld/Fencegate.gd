extends Node2D

var is_inside = false
var is_open = false

onready var gate = $Sprite

func _process(_delta):
	if is_inside == true and Input.is_action_just_released("interact"):
		if is_open == true:
			gate.frame = 0
			$Gate/CollisionShape2D.disabled = false
		
		if is_open == false:
			gate.frame = 1
			$Gate/CollisionShape2D.disabled = true
			
		is_open = !is_open


func _on_InteractArea_area_entered(_area):
	is_inside = true


func _on_InteractArea_area_exited(_area):
	is_inside = false
