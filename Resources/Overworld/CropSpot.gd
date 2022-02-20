extends KinematicBody2D

var is_inside = false

func _process(_delta):
	if is_inside == true and Input.is_action_just_released("interact"):
		var item_name =  "Carrot"
		PlayerInventory.add_item(item_name, 1, "Hotbar")
		print("Carrot collected!")
		queue_free()


func _on_CarrotArea_area_entered(_area):
	is_inside = true


func _on_CarrotArea_area_exited(_area):
	is_inside = false
