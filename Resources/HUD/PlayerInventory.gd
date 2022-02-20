extends Node

signal active_item_updated

const SlotClass = preload("res://Resources/HUD/Slot.gd")
const ItemClass = preload("res://Resources/HUD/Item.gd")

const HOTBAR_SLOT_TOTAL = 8

var slot_total = 0
var inv_selected = null
var current_inv = null

var holding_item = null
var active_item_slot = 0

var hotbar = {
	0: ["Pail", 1],
	7: ["Carrot", 4]
}

var inventory = {
	0: ["Carrot", 1],
}

func add_item(item_name, item_quantity, inv_type):
	current_inv = inv_type
	if inv_type == "Inventory":
		slot_total = HOTBAR_SLOT_TOTAL
		inv_selected = inventory
		
	if inv_type == "Hotbar":
		slot_total = HOTBAR_SLOT_TOTAL
		inv_selected = hotbar
		
	for item in inv_selected:
		if inv_selected[item][0] == item_name:
			var stack_size = int(Global.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - inv_selected[item][1]
			if able_to_add >= item_quantity:
				inv_selected[item][1] += item_quantity
				update_slot_visual(item, inv_selected[item][0], inv_selected[item][1])
				return
			else:
				inv_selected[item][1] += able_to_add
				update_slot_visual(item, inv_selected[item][0], inv_selected[item][1])
				item_quantity -= able_to_add
			
	for item in range(slot_total):
		if inv_selected.has(item) == false:
			inv_selected[item] = [item_name, item_quantity]
			update_slot_visual(item, inv_selected[item][0], inv_selected[item][1])
			return


func update_slot_visual(slot_index, item_name, item_quantity):
	#TODO: fix node path
	var slot = get_tree().get_root().get_node("/root/SceneManager/UserInterface/Hotbar/Slots/Slot" + str(slot_index + 1))
	if slot.item != null:
		slot.item.set_item(item_name, item_quantity) 
	else:
		slot.init_item(item_name, item_quantity)


func add_item_empty_slot(item: ItemClass, slot: SlotClass):
	match slot.slot_type:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index] = [item.item_name, item.item_quantity]
			
		SlotClass.SlotType.INVENTORY:	
			inventory[slot.slot_index] = [item.item_name, item.item_quantity]
				
		#_:
			#equips[slot.slot_index] = [item.item_name, item.item_quantity]

func remove_item(slot: SlotClass):
	match slot.slot_type:
		SlotClass.SlotType.HOTBAR:
			hotbar.erase(slot.slot_index)
		
		SlotClass.SlotType.INVENTORY:	
			inventory.erase(slot.slot_index)
			
		#_:
			#equips.erase(slot.slot_index)
	
	
func add_item_quantity(slot: SlotClass, quantity_to_add: int):
	match slot.slot_type:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index][1] += quantity_to_add
			
		SlotClass.SlotType.INVENTORY:	
			inventory[slot.slot_index][1] += quantity_to_add
				
		#_:
			#equips[slot.slot_index][1] += quantity_to_add
			
func remove_item_quantity(slot: SlotClass, quantity_to_remove: int):
	match slot.slot_type:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index][1] -= quantity_to_remove
			print(hotbar[slot.slot_index][1])
			
		SlotClass.SlotType.INVENTORY:	
			inventory[slot.slot_index][1] -= quantity_to_remove
				
		#_:
			#equips[slot.slot_index][1] += quantity_to_add


func active_item_change(slot_num):
	active_item_slot = slot_num
	emit_signal("active_item_updated")
		

func active_item_scroll_up():
	active_item_slot = (active_item_slot + 1) % HOTBAR_SLOT_TOTAL
	emit_signal("active_item_updated")
	
	
func active_item_scroll_down():
	if active_item_slot == 0:
		active_item_slot = HOTBAR_SLOT_TOTAL - 1
	else:
		active_item_slot -= 1
	emit_signal("active_item_updated")
func _input(_event):
	if holding_item:
		holding_item.global_position = get_viewport().get_mouse_position()


func able_to_put_into_slot(slot: SlotClass):
	if holding_item == null:
		return true
	#var holding_item_category = Global.item_data[holding_item.item_name]["Category"]
	
	if slot.slot_type == SlotClass.SlotType.HOTBAR:
		return true


func left_click_empty_slot(slot):
	if able_to_put_into_slot(slot):
		add_item_empty_slot(holding_item, slot)
		slot.put_into_slot(holding_item)
		holding_item = null


func left_click_different_item(event: InputEvent, slot: SlotClass):
	if able_to_put_into_slot(slot):
		remove_item(slot)
		add_item_empty_slot(holding_item, slot)
		var temp_item = slot.item
		slot.pick_from_slot()
		temp_item.global_position = event.global_position
		slot.put_into_slot(holding_item)
		holding_item = temp_item
	
	
func left_click_same_item(slot: SlotClass):
	if able_to_put_into_slot(slot):
		var stack_size = int(Global.item_data[slot.item.item_name]["StackSize"])
		var able_to_add = stack_size - slot.item.item_quantity
		
		if able_to_add >= holding_item.item_quantity:
			add_item_quantity(slot, holding_item.item_quantity)
			slot.item.add_item_quantity(holding_item.item_quantity)
			holding_item.queue_free()
			holding_item = null
		else:
			add_item_quantity(slot, able_to_add)
			slot.item.add_item_quantity(able_to_add)
			holding_item.decrease_item_quantity(able_to_add)
		
		
func left_click_not_holding(slot: SlotClass):
	remove_item(slot)
	holding_item = slot.item
	slot.pick_from_slot()
	holding_item.global_position = get_viewport().get_mouse_position()
	
	
func right_click_not_holding(slot: SlotClass):
	if holding_item == null and slot != null:
		if slot.item.item_quantity > 1:
			var holding_value = floor(slot.item.item_quantity / 2)
			var slot_value = ceil(slot.item.item_quantity / 2)
			var item_halfed = slot.item
			var index = slot.slot_index
			
			slot.item.set_item_quantity(holding_value)
			
			remove_item(slot)
			holding_item = slot.item
			slot.pick_from_slot()
			
			holding_item.global_position = get_viewport().get_mouse_position()
		
			inventory[index] = [item_halfed.item_name, slot_value]
			update_slot_visual(index, inventory[index][0], inventory[index][1])


