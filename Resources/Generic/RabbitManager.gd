extends Node
var path = Global.path + "/locations/"

var state_variants = [
	[["WALK", 0.75], ["IDLE", 0.25]],
	[["WALK", 0.25], ["IDLE", 0.75]]
	]

var rabbits = {
#   name            state chances       speed
	"Normal" 	: 	[state_variants[0], 10],
	"Stone" 	: 	[state_variants[1], 5]
}


func decide_type():
	randomize()
	var key_list = rabbits.keys()
	var key = key_list[randi() % key_list.size()]
	
	return key


func decide_state(type):
	var current_state = null
	var states = rabbits[type][0]
	
	randomize()
	var s = rand_range(0, 1)
	var remainder = 1
	
	var previous = 1
	for i in states.size():
		remainder -= states[i][1]
		if (s >= remainder && s < previous):
			current_state = states[i][0]
			break
		if remainder == 0:
			print("Whoops")
		else:
			previous -= states[i][1]
			
	return current_state


func save_data(id, direct, rabbit_data):
	direct = "/" + direct + "/"
	var dir = Directory.new()
	if !dir.dir_exists(path):
		dir.make_dir_recursive(path)
		print("Made dir")


	## save data
	var save_path = path + direct + id + ".json"
	
	var file = File.new()
	var error = file.open(save_path, File.WRITE)
	if error == OK:
		file.store_line(to_json(rabbit_data))
		file.close()

	print("Saved data for: " + id)
