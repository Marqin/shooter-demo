extends KinematicBody

var yaw = 0.0
var pitch = 0.0
var view_sensitivity = 0.5
var shooting = false
# must be "onready var", becasue "vision/aim" might not be available
# during GDScript compilation - it woul error
onready var aim = get_node("vision/aim")

func _ready():
	# we want to process whole input, not only clicks made on player
	set_process_input(true)
	# we want to do our physics in fixed timestep,
	# this is also the only place for safe raycasting
	set_fixed_process(true)

func _fixed_process(delta):
	# we allow continuous shooting - full-auto machine gun
	if shooting:
		# set_cast_to is relative to "vision" node position!
		# we just aim in front of camera (range is 1000)
		aim.set_cast_to(Vector3(0,0,-1000))
		if aim.is_colliding():
			var collider = aim.get_collider()
			# collider might be queued for removal, so we need that check:
			if collider == null:
				return
			# get_collision_point() gives us point in GLOBAL coordinate system
			# so we have to cast it trough our parent's transform (inverted)
			# to get point in OUR PARENT'S coordinate system, so we can spawn
			# particle his child in proper place
			var point = aim.get_collision_point()
			point = get_parent().get_global_transform().xform_inv(point)
			# this is a simple particle, that shows where we hit
			var hit = load("res://hit.tscn").instance()
			hit.translate(point)
			get_parent().add_child(hit)
			# if we hit enemy - kill it
			if collider.get_filename() == "res://enemy.tscn":
				collider.queue_free()

func _input(event):
	if event.type == InputEvent.MOUSE_MOTION:
		# math for camera rotation, taken from other tutorial
		var yaw = rad2deg(get_rotation().y);
		var pitch = rad2deg(get_node("vision").get_rotation().x);
		yaw = fmod(yaw - event.relative_x * view_sensitivity, 360);
		pitch = max(min(pitch - event.relative_y * view_sensitivity, 90), -90);
		set_rotation(Vector3(0, deg2rad(yaw), 0));
		get_node("vision").set_rotation(Vector3(deg2rad(pitch), 0, 0));
	if event.type == InputEvent.MOUSE_BUTTON:
		# we get this event twice, once when Mouse Button is pressed
		# and once when it's released
		if event.pressed:
			shooting = true
		else:
			shooting = false
