extends Node2D

const SlotClass = preload("res://Resources/HUD/Slot.gd")
const MAX_FOOD = 6

onready var hotbar_slots = get_tree().get_root().get_node("/root/SceneManager/UserInterface/Hotbar/Slots")
onready var slots = hotbar_slots.get_children()

export(int) var food_amount
var is_in_area = false


func _ready():
	$Sprite.frame = food_amount

func _process(_delta):
	$Level.text = str(food_amount) + "/" + str(MAX_FOOD)
	
	if is_in_area == true and Input.is_action_just_pressed("refill_feed"):
		var active_hotbar_slot = PlayerInventory.active_item_slot
		
		if PlayerInventory.hotbar.has(active_hotbar_slot):
			var active_hotbar_item = PlayerInventory.hotbar[active_hotbar_slot]
			var current_slot = hotbar_slots.get_node("Slot" + str(active_hotbar_slot + 1))
				
			
			if active_hotbar_item[0] == "Carrot":
				if food_amount < 6:
					if active_hotbar_item[1] == 1:
						PlayerInventory.remove_item(current_slot)
						current_slot.item.queue_free()
						
						hotbar_slots.get_parent().update_active_item_label()
						print(PlayerInventory.hotbar)
						
					elif active_hotbar_item[1] > 1:
						current_slot.item.decrease_item_quantity(1)
						active_hotbar_item[1] -= 1
						
					food_amount += 1
					$Sprite.frame += 1
					print("Refill food!")
						
				elif food_amount + 1 > 6:
					print("Food full!")
			
				


func can_decrease():
	if food_amount <= 0:
		return false
	else:
		return true


func decrease_food():
	$Sprite.frame -= 1
	food_amount -= 1


func _on_RefillArea_area_entered(_area):
	is_in_area = true


func _on_RefillArea_area_exited(_area):
	is_in_area = false
