extends CanvasLayer

var is_paused = false setget set_is_paused


func _unhandled_input(event):
	if event.is_action_pressed("menu"):
		self.is_paused = !is_paused


func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	$Pause.visible = is_paused


func _on_Resume_pressed():
	self.is_paused = false


func _on_Quit_pressed():
	get_tree().quit()


func _on_Save_pressed():
	PlayerData.username = "Player"
	PlayerData.save_game()


func _on_Load_pressed():
	PlayerData.username = "Player"
	PlayerData.load_game()
