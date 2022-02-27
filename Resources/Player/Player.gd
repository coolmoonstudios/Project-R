extends KinematicBody2D

onready var camera = get_tree().get_root().get_node("/root/SceneManager/Camera2D/")
onready var anim_tree = $AnimationTree
onready var anim_state = anim_tree.get("parameters/playback")

const ACCELERATION = 300
const FRICTION = 800
const MAX_SPEED = 50
const RUN_SPEED = 80

var velocity = Vector2.ZERO

var holding = false
var rabbit_in_area = null
var held_rabbit = null
var area_entered = false
var max_speed

func _physics_process(delta):
	camera.position = position
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") -  Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") -  Input.get_action_strength("move_up")
	
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		anim_tree.set("parameters/Walk/blend_position", input_vector)
		anim_tree.set("parameters/Idle/blend_position", input_vector)
		anim_state.travel("Walk")
		if Input.is_action_pressed("run") and PlayerData.action > 0:
			PlayerData.action -= 1
			max_speed = RUN_SPEED
		else:
			max_speed = MAX_SPEED
			
		velocity = velocity.move_toward(input_vector * max_speed, ACCELERATION * delta)
	else:
		anim_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	if PlayerData.action < 1000 and !Input.is_action_pressed("run"):
		PlayerData.action += 1
		
	if holding == true and held_rabbit != null:
		held_rabbit.position = position + Vector2(0, -8)
		#held_rabbit.sprite.flip_h = sprite.flip_h
	
	# displays items in players hands
	if holding == false and PlayerInventory.active_item_slot in PlayerInventory.hotbar.keys():
		var active = PlayerInventory.hotbar[PlayerInventory.active_item_slot]
		$ItemHolding.texture = load("res://Textures/Materials/Items/" + active[0] + ".png")
	else:
		$ItemHolding.texture = null
	
	velocity = move_and_slide(velocity)


func _process(_delta):
	if holding == true and Input.is_action_just_pressed("pickup_rabbit"):
		holding = false
		held_rabbit.rabbit_held = false
		held_rabbit = null
	else:
		if area_entered == true and Input.is_action_just_pressed("pickup_rabbit"):
			held_rabbit = rabbit_in_area
			held_rabbit.position = position + Vector2(0, -9)
			held_rabbit.rabbit_held = true
			holding = true

func _on_FindRabbit_area_entered(area):
	if area.name == "PickupArea" and holding == false:
		rabbit_in_area = area.get_parent()
		area_entered = true


func _on_FindRabbit_area_exited(area):
	if area.name == "PickupArea" and holding == false:
		area_entered = false
		rabbit_in_area = null
