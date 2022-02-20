extends Node2D

const SlotClass = preload("res://Resources/HUD/Slot.gd")

onready var hotbar_slots = $Slots
onready var slots = hotbar_slots.get_children()
onready var active_item_label = $ActiveItemLabel

func _ready():
	PlayerInventory.connect("active_item_updated", self, "update_active_item_label")
		
	for i in range(slots.size()):
		PlayerInventory.connect("active_item_updated", slots[i], "update_slot_style")
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i
		slots[i].slot_type = SlotClass.SlotType.HOTBAR
		slots[i].update_slot_style()
	initialize_hotbar()
	update_active_item_label()


func initialize_hotbar():
	for i in range(slots.size()):
		if PlayerInventory.hotbar.has(i):
			slots[i].init_item(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1])


func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			update_active_item_label()
			if PlayerInventory.holding_item != null:
				if !slot.item:
					PlayerInventory.left_click_empty_slot(slot)
					update_active_item_label()
				else:
					if PlayerInventory.holding_item.item_name != slot.item.item_name:
						PlayerInventory.left_click_different_item(event, slot)
						update_active_item_label()
					else:
						PlayerInventory.left_click_same_item(slot)					
						update_active_item_label()

			elif slot.item:
				PlayerInventory.left_click_not_holding(slot)
				update_active_item_label()


func update_active_item_label():
	if slots[PlayerInventory.active_item_slot].item != null:
		active_item_label.text = slots[PlayerInventory.active_item_slot].item.item_name
	else:
		active_item_label.text = ""
