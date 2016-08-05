extends Spatial

const max_enemies = 10
const enemy_name = "res://enemy.tscn"

# returns random float in range (-50, -5)(5, 50)
func our_rand():
	var r = rand_range(-45.0, 45.0)
	if r >= 0:
		r += 5.0
	else:
		r -= 5.0
	return r

func _ready():
	# without it rand() would give the same numbers on every run
	randomize()
	# we load our enemy scene
	var enemy = load(enemy_name)
	for i in range(max_enemies):
		# and now we instance it
		var e = enemy.instance()
		# translate
		e.translate(Vector3(our_rand(), our_rand(), our_rand()))
		# and add to map
		add_child(e)
	set_fixed_process(true)

func _fixed_process(delta):
	var count = 0
	for i in get_children():
		if i.get_filename() == enemy_name:
			count += 1
	if count == 0:
		# we won the game
		get_node("player/vision/points").set_pos(Vector2(350,270))
		get_node("player/vision/points").set_scale(Vector2(5,5))
		get_node("player/vision/points").set_text("YOU WIN!")
	else:
		# show how much enemies left
		get_node("player/vision/points").set_text("Left: " + str(count))
