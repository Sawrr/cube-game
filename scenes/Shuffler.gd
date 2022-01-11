extends Node

const NUM_SHUFFLES = 20

func generate_shuffles():
	var shuffles = []

	var last_axis_vector: Vector3
	var last_group_vector: Vector3

	randomize() # set random seed

	for i in range(NUM_SHUFFLES):
		var shuffle = _generate_shuffle()

		# don't undo a previous shuffle
		if shuffle.group == last_group_vector:
			if shuffle.axis.is_equal_approx(last_axis_vector * -1):
				i -= 1
				continue

		# store last shuffle
		last_axis_vector = shuffle.axis
		last_group_vector = shuffle.group

		shuffles.append(shuffle)
	return shuffles

func _generate_shuffle():
	var axis = randi() % 3
	var side = randi() % 2
	var group_vector = Vector3()
	group_vector[axis] = 1 if side else -1
	var axis_vector = group_vector
	var clockwise = randi() % 2
	axis_vector = axis_vector * (1 if clockwise else -1)
	return { "axis": axis_vector, "group": group_vector }
