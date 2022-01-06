extends Area

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
				print("ended drag by changing sides")

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
					print("ended drag, drag was not straight")
				else:
					dragging = false
					print("full drag completed")

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
					print("too close to center or corner")
					return

				dragging = true
				drag_start_pos = rounded_pos
				drag_start_axis = _max_axis(normal)

				print("began drag")
			else:
				if dragging:
					dragging = false
					print("ended drag by releasing")

func _on_Area_mouse_exited():
	if dragging:
		dragging = false
		print("ended drag by leaving bounds")
