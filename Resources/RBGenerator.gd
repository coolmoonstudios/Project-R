extends Node2D

onready var new_owner = get_parent().get_parent().get_node("YSort")

export var max_rabbits = 5

var rabbits_made = 0
var rabbit = preload("res://Resources/Rabbit/WildRabbit.tscn")
var rng = RandomNumberGenerator.new()

func _ready():
	make_rabbit()


func make_rabbit():
	rng.randomize()
	
	var new_rabbit = rabbit.instance()
	new_rabbit.rabbit_type = RabbitManager.decide_type()
	new_rabbit.rabbit_speed = RabbitManager.rabbits[new_rabbit.rabbit_type][1]
	new_rabbit.position = position + Vector2(rng.randi_range(-2, 2), rng.randi_range(-2, 2))
	new_rabbit.owner = new_owner
	new_owner.call_deferred("add_child", new_rabbit)
	
	rabbits_made += 1
	$Timer.wait_time = rng.randi_range(10, 15)
	$Timer.start()


func _on_Timer_timeout():
	if rabbits_made < max_rabbits + 1:
		make_rabbit()
