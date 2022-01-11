extends Spatial

enum GameState { PLAYER, SHUFFLING }
var game_state

var animating: bool

var shuffles: Array

onready var cube = $WholeCube
onready var shuffler = $Shuffler

func _ready():
	game_state = GameState.PLAYER

	# TEMP
	shuffle_cube()

func _on_WholeCube_animation_done():
	animating = false
	if game_state == GameState.SHUFFLING:
		if shuffles.size():
			_shuffle()
		else:
			game_state = GameState.PLAYER

func _on_WholeCube_cube_solved():
	print("Cube solved! Congrats.")

func _on_DraggableArea_drag(rotation_axis_vector, rotating_group_vector):
	if game_state == GameState.PLAYER and !animating:
		animating = true
		cube.rotate_cubes(rotation_axis_vector, rotating_group_vector)

func shuffle_cube():
	game_state = GameState.SHUFFLING
	shuffles = shuffler.generate_shuffles()
	_shuffle()

func _shuffle():
	var shuffle = shuffles.pop_front()
	animating = true
	cube.rotate_cubes(shuffle.axis, shuffle.group, true)
