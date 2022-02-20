extends Panel

var default_tex = preload("res://Textures/HUD/item_slot_default.png")
var selected_tex = preload("res://Textures/HUD/item_slot_selected.png")
var default_style: StyleBoxTexture = null
var selected_style: StyleBoxTexture = null

var ItemClass = preload("res://Resources/HUD/Item.tscn")
var item = null
var slot_index

var slot_type

enum SlotType {
	HOTBAR = 0,
	INVENTORY
}

func _ready():
	default_style = StyleBoxTexture.new()
	selected_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	selected_style.texture = selected_tex
	
	update_slot_style()

func update_slot_style():
	if slot_type == SlotType.HOTBAR and PlayerInventory.active_item_slot == slot_index:
		set('custom_styles/panel', selected_style)
	else:
		set('custom_styles/panel', default_style)


func pick_from_slot():
	remove_child(item)
	var interfaceNode = find_parent("UserInterface")
	interfaceNode.add_child(item)
	item = null
	update_slot_style()
	
func pick_from_slot_with_quantity():
	var interfaceNode = find_parent("UserInterface")
	interfaceNode.add_child(item)
	item = null
	update_slot_style()


func put_into_slot(new_item):
	item = new_item
	item.position = Vector2(0, 0)
	var interfaceNode = find_parent("UserInterface")
	interfaceNode.remove_child(item)
	add_child(item)
	update_slot_style()


func init_item(item_name, item_quantity):
	if item == null:
		item = ItemClass.instance()
		add_child(item)
		item.set_item(item_name, item_quantity)
	else:
		item.set_item(item_name, item_quantity)
		update_slot_style()
		
