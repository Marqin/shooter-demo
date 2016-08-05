extends Particles

var time = 0

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	time += delta
	# despawn after 1 second
	if time > 1.0:
		queue_free()