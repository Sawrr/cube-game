extends Spatial

signal animation_done

const ROTATION_TIME = 0.5

var animating = false
var anim_time_counter = 0

var rotator: Spatial

var rotating_cubes: Array = []
var rotation_axis_vector: Vector3
var rotating_group_vector: Vector3

func _ready():
	rotator = $Rotator

func _process(delta: float):
	if animating:
		_rotate(delta)

func rotate_cubes(rotation_axis: Vector3, rotating_group: Vector3):
	if !animating:
		rotation_axis_vector = rotation_axis
		rotating_group_vector = rotating_group

		_begin_rotating()

func _begin_rotating():
	# Identify cubes that need to rotate
	var cube_groups = get_children()
	for cube_group in cube_groups:
		var cubes = cube_group.get_children()
		for cube in cubes:
			var cube_pos: Vector3 = cube.transform.origin
			if is_equal_approx(cube_pos.dot(rotating_group_vector), 1):
				rotating_cubes.append(cube)

	# Re-parent cubes to rotator
	for cube in rotating_cubes:
		cube.get_parent().remove_child(cube)
		rotator.add_child(cube)

	# start animating
	animating = true

func _rotate(delta: float):
	# increment counter
	anim_time_counter += delta
	anim_time_counter = clamp(anim_time_counter, 0, ROTATION_TIME)
	var rotation_fraction = anim_time_counter / ROTATION_TIME

	# Rotate cubes on axis
	rotator.transform = Transform.IDENTITY.rotated(rotation_axis_vector, rotation_fraction * PI / 2)

	if anim_time_counter == ROTATION_TIME:
		# done rotating
		_end_rotating()

func _end_rotating():
	# Re-parent cubes back to their original parents
	for cube in rotating_cubes:
		var new_global_transform = cube.global_transform
		cube.get_parent().remove_child(cube)
		cube.set_global_transform(new_global_transform)
		cube.original_parent.add_child(cube)

	# Reset rotator transform
	rotator.transform = Transform.IDENTITY

	# Reset cube list
	rotating_cubes.clear()

	# done animating
	animating = false
	anim_time_counter = 0
