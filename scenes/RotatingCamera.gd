extends Spatial

const PIXEL_TO_ROTATION = 100.0

var rotating = false
var mouse_screen_pos: Vector2

func _input(event):
	if event.is_class("InputEventMouseMotion"):
		var e = event as InputEventMouseMotion
		if rotating:
			var diff_pos = e.position - mouse_screen_pos

			# rotate camera based on motion
			var yaw = diff_pos.x / PIXEL_TO_ROTATION
			var pitch = -diff_pos.y / PIXEL_TO_ROTATION
			transform = transform.rotated(Vector3.UP, yaw)
			transform = transform.rotated(transform.basis.xform(Vector3.RIGHT), pitch)

			# reset current screen position
			mouse_screen_pos = e.position
	elif event.is_class("InputEventMouseButton"):
		var e = event as InputEventMouseButton
		if e.button_index == BUTTON_MIDDLE:
			if e.pressed:
				mouse_screen_pos = e.position
				rotating = true
			else:
				rotating = false
