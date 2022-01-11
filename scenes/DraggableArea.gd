extends Area

signal drag

const DRAG_DISTANCE = 1.0
const DRAG_ANGLE = PI/8

var dragging: bool = false
var drag_start_pos: Vector3
var drag_start_axis: int

func _round_vector(vec: Vector3, amount: float) -> Vector3:
	return Vector3(stepify(vec.x, amount), stepify(vec.y, amount), stepify(vec.z, amount))

func _max_axis(vec: Vector3):
	return Vector3(abs(vec.x), abs(vec.y), abs(vec.z)).max_axis()

func _on_Area_input_event(camera, event: InputEventMouse, position, normal, shape_idx):
	var rounded_pos = _round_vector(position, 0.01)

	# Remove bad data
	if rounded_pos.length() > 3:
		return

	# Check input type
	if event.is_class("InputEventMouseMotion"):
		var e = event as InputEventMouseMotion

		if dragging:
			# check for changing sides of cube
			if drag_start_axis != _max_axis(normal):
				dragging = false

			# check for sufficient drag distance
			var start_coords = []
			var curr_coords = []
			for i in range(3):
				if i != drag_start_axis:
					start_coords.append(drag_start_pos[i])
					curr_coords.append(rounded_pos[i])
			var start_vec2 = Vector2(start_coords[0], start_coords[1])
			var curr_vec2 = Vector2(curr_coords[0], curr_coords[1])
			var diff_vec2 = start_vec2 - curr_vec2

			if diff_vec2.length() > DRAG_DISTANCE:
				# ignore if angle was not mostly straight
				var abs_diff_vec2 = Vector2(abs(diff_vec2.x), abs(diff_vec2.y))
				if abs(abs_diff_vec2.angle_to(Vector2(1, 1))) < DRAG_ANGLE:
					dragging = false
				else:
					dragging = false

					var diff_vector  = rounded_pos - drag_start_pos
					var max_axis = _max_axis(diff_vector)
					var drag_vector = Vector3()
					drag_vector[max_axis] = 1 if diff_vector[max_axis] > 0 else -1

					var normal_vector = Vector3()
					normal_vector[drag_start_axis] = 1 if drag_start_pos[drag_start_axis] > 0 else -1

					var rotation_axis_vector = normal_vector.cross(drag_vector)
					var rotating_group_vector = rotation_axis_vector.abs()
					rotating_group_vector *= 1 if drag_start_pos[_max_axis(rotation_axis_vector)] > 0 else -1

					emit_signal("drag", rotation_axis_vector, rotating_group_vector)

	elif event.is_class("InputEventMouseButton"):
		var e = event as InputEventMouseButton

		# check for left mouse button
		if e.button_index == BUTTON_LEFT:

			if e.pressed:

				# ignore if clicking too close to centers or corners
				var side_count = 0
				var center_count = 0
				for i in range(3):
					if abs(rounded_pos[i]) >= 1.49 and abs(rounded_pos[i]) <= 1.51:
						side_count += 1

					if abs(rounded_pos[i]) < 0.5:
						center_count += 1
				if side_count != 1 or center_count > 1:
					return

				dragging = true
				drag_start_pos = rounded_pos
				drag_start_axis = _max_axis(normal)
			else:
				if dragging:
					dragging = false

func _on_Area_mouse_exited():
	if dragging:
		dragging = false
