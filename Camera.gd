extends Camera2D

var player = null
var hud = null


func _ready():
	player = get_parent().find_node("Player")
	
	
func _process(delta):
	print(player)
		
	if is_instance_valid(player):
		print("Player!")
		position = player.position
		
