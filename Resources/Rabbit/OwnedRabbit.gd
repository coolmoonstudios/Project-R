extends KinematicBody2D

const MAX_WATER = 40	#40
const MAX_FOOD = 40		#40

var current_state = null

var rabbit_held = false
var can_move_path = false
var velocity = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var path : = PoolVector2Array() setget set_path

var rabbit_type
var rabbit_speed

var food_level = MAX_FOOD
var needs_water = false
var water_level = MAX_WATER
var needs_food = false

onready var anim_tree = $AnimationTree
onready var anim_state = anim_tree.get("parameters/playback")

onready var world = get_parent().get_parent()

onready var nav_2d = world.get_node("Navigation2D")
onready var line_2d = $Line2D
onready var rabbit = self

onready var water_trough = world.get_node("YSort/WaterTrough")
onready var food_trough = world.get_node("YSort/FoodTrough")

func _ready():
	rabbit_speed = Global.rabbits[rabbit_type][1]
	$Sprite.texture = load("res://Textures/Rabbits/" + rabbit_type.to_lower() + ".png")
	manage_state()

func _process(delta):
	if rabbit_held == false:
		
		if can_move_path == true:
			var move_dist = rabbit_speed * delta
			move_along_path(move_dist)
		else:
			$CollisionShape2D.disabled = false
			$Sprite.z_index = 0
			velocity = move_and_slide(velocity)
		
	if rabbit_held == true:
		$CollisionShape2D.disabled = true
		$Sprite.z_index = 1


func decide_dir():
	randomize()
	var directions = [1, -1]
	var dir = Vector2.ZERO
	rng.randomize()
	
	var des = rng.randi_range(0, 1)
	if des == 0:
		dir.x = directions[rng.randi_range(0, 1)]
	else:
		dir.y = directions[rng.randi_range(0, 1)]
	
	dir.normalized()
	
	return dir


func move(dir):
	velocity.x = dir.x * rabbit_speed
	velocity.y = dir.y * rabbit_speed
	
	anim_tree.set("parameters/Walk/blend_position", dir)
	anim_state.travel("Walk")


func _on_Timer_timeout():
	if rabbit_held == false and can_move_path == false:
		velocity = Vector2.ZERO
		manage_state()
		
	$Timer.wait_time = rand_range(3, 8)


func manage_state():
	current_state = RabbitManager.decide_state(rabbit_type)
	
	if needs_water == true:
		make_path()
		can_move_path = true
	elif needs_food == true:
		make_path()
		can_move_path = true
	else:
		if current_state == "WALK":
			move(decide_dir())
		if current_state == "IDLE":
			pass


func move_along_path(dist):
	var last_point = position
	for _i in range(path.size()):
		var dist_next_point = last_point.distance_to(path[0])
		if dist <= dist_next_point and dist >= 0.0:
			position = last_point.linear_interpolate(path[0], dist / dist_next_point)
			anim_tree.set("parameters/Walk/blend_position", last_point.direction_to(path[0]))
			anim_state.travel("Walk")
			break
		elif path.size() == 1 and dist >= dist_next_point:
			position = path[0]
			
			# manage water refilling
			if water_level < MAX_WATER:
				if water_trough.can_decrease():
					water_level = MAX_WATER
					decrease_water()
				else:
					print("No water in trough!")
				
			# manage food refilling
			if food_level < MAX_FOOD:
				print(food_trough.can_decrease())
				if food_trough.can_decrease() == true:
					food_level = MAX_FOOD
					food_trough.decrease_food()
				else:
					print("No food in trough!")
				
			can_move_path = false
			break
			
		dist -= dist_next_point
		last_point = path[0]
		path.remove(0)
			
			#if needs_food == true:
			#	food_level = 10
			#	needs_food == false
			#	$FoodTimer.start()


func set_path(value):
	path = value
	if value.size() == 0:
		return
	path.remove(0)
	can_move_path = true


func make_path():
	var trough
	if needs_water == true:
		trough = water_trough
	if needs_food == true:
		trough = food_trough
	
	var new_path = nav_2d.get_simple_path(
		rabbit.position, 
		trough.position - Vector2(0, -8)
	)
	
	rabbit.path = new_path
	line_2d.points = new_path


func decrease_water():
	water_level -= 1
	needs_water = false
	$Timer.wait_time = rand_range(16, 24)
	$WaterTimer.start()


func decrease_food():
	food_level -= 1
	needs_food = false
	$Timer.wait_time = rand_range(16, 24)
	$FoodTimer.start()


func _on_WaterTimer_timeout():
	
	if water_level - 1 == 0:
		needs_water = true
		
	elif needs_water == false:
		decrease_water()


func _on_FoodTimer_timeout():
	
	if food_level - 1 == 0:
		needs_food = true
		
	elif needs_food == false:
		decrease_food()

