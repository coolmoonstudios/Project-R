extends CanvasModulate

const MORNING_COLOR = Color("#d4b78c")
const DAY_COLOR = Color("#d1d1d1")
const EVENING_COLOR = Color("#d4b78c")
const NIGHT_COLOR = Color("#1a212b")

var hours = 6
var mins = 0
var wait_time = 10

onready var timer = $Timer
onready var time_display = get_parent().get_node("UserInterface/Time/Label")

func _ready():
	$Timer.wait_time = wait_time
	

func reset_data():
	PlayerData.time = 0
	hours = 6
	mins = 0
	wait_time = 10
	
	time_display.text = str(hours) + ":00"

func _process(_delta):
	
	if hours == 6:
		# how many sets of wait_time do you want to wait for
		var segments = 3
		
		$Tween.interpolate_property(self, "color", MORNING_COLOR, DAY_COLOR, wait_time * segments)
		$Tween.start()
		
		
	if hours == 17:
		var segments = 8
		$Tween.interpolate_property(self, "color", DAY_COLOR, EVENING_COLOR, wait_time * segments)
		$Tween.start()
	
	
	if hours == 22:
		var segments = 2
		$Tween.interpolate_property(self, "color", EVENING_COLOR, NIGHT_COLOR, wait_time * segments)
		$Tween.start()
	
	if Global.disable_light == true:
		color = DAY_COLOR

func _on_Timer_timeout():
	if mins < 60:
		mins += 10
	if mins == 60:
		hours += 1
		mins = 00
	
	if mins != 0:
		time_display.text = str(hours) + ":" + str(mins)
	else:
		time_display.text = str(hours) + ":00"
		
	if hours == 24:
		print("End of day!")
		hours = 6
		mins = 0
		PlayerData.time = 0
	else:
		PlayerData.time += 1
	
	$Timer.start()
	
	print("Time: " + str(PlayerData.time))
