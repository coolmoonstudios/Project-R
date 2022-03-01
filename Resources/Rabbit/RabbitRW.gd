extends KinematicBody2D

var rabbit_data = {
	"type" : "Normal",
	"position" : Vector2(30, 30)
}

func save_data():
	RabbitManager.save_data(name, "WildArea", rabbit_data)
