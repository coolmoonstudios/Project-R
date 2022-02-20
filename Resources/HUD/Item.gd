extends Node2D

var item_name
var item_quantity

func _ready():
	item_name = Global.vegetables[randi() % Global.vegetables.size()]
	
	$TextureRect.texture = load("res://Textures/Materials/Items/" + item_name + ".png")
	var stack_size = int(Global.item_data[item_name]["StackSize"])
	item_quantity = randi() % stack_size + 1

	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.text = String(item_quantity)


func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$Label.text = String(item_quantity)


func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	$Label.text = String(item_quantity)


func set_item_quantity(amount_to_set):
	item_quantity = amount_to_set
	$Label.text = String(item_quantity)


func set_item(input_item_name, input_item_quantity):
	item_name = input_item_name
	item_quantity = input_item_quantity
	
	$TextureRect.texture = load("res://Textures/Materials/Items/" + item_name + ".png")

	var stack_size = int(Global.item_data[item_name]["StackSize"])
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.visible = true
		$Label.text = str(item_quantity)
