extends CanvasLayer

func _input(event):
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_item_scroll_down()
		
	elif event.is_action_pressed("scroll_down"):
		PlayerInventory.active_item_scroll_up()
		

func _process(_delta):
	$Day/Label.text = str(PlayerData.season) + ": "+ str(PlayerData.day)
	$Health/Label.text = str(PlayerData.health)
	$Energy/Label.text = str(PlayerData.energy)
	$Action/Label.text = str(PlayerData.action)
