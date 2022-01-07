extends MeshInstance

var correct_transform: Transform
var original_parent: Spatial

func _ready():
	correct_transform = self.transform
	original_parent = self.get_parent()
