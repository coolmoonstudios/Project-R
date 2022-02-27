extends CanvasLayer

func _input(event):
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_item_scroll_down()
		
	elif event.is_action_pressed("scroll_down"):
		PlayerInventory.active_item_scroll_up()
		

func _process(_delta):
	$Day/Label.text = str(PlayerData.season) + ": "+ str(PlayerData.day)
	$Health/HealthBar.value = PlayerData.health
	$Health/HealthBar.hint_tooltip = str(PlayerData.health)
	$Action/ActionBar.value = PlayerData.action
	$Action/ActionBar.hint_tooltip = str(PlayerData.action)
