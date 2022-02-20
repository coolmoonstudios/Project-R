extends Node2D

const MAX_WATER = 30

export(int) var water_amount

func _process(_delta):
	$Level.text = str(water_amount) + "/" + str(MAX_WATER)
	
	if water_amount > 20 and water_amount < 31:
		$Sprite.frame = 0
	if water_amount > 10 and water_amount < 21:
		$Sprite.frame = 1
	if water_amount > 0 and water_amount < 11:
		$Sprite.frame = 2
	if water_amount == 0:
		$Sprite.frame = 3


func can_decrease():
	if water_amount <= 0:
		return false
	else:
		return true


func decrease_water():
	water_amount -= 1
