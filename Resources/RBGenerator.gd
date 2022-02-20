extends Node2D

var rabbit = preload("res://Resources/Rabbit/Rabbit.tscn")

func _ready():
	var new_rabbit = rabbit.instance()
	new_rabbit.rabbit_type = Global.decide_type()
	new_rabbit.rabbit_speed = Global.rabbits[new_rabbit.rabbit_type][1]
	new_rabbit.position = position
	new_rabbit.gen_owner = get_parent()
	get_parent().call_deferred("add_child", new_rabbit)
	#queue_free()
	

