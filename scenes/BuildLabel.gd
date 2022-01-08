extends RichTextLabel

const BUILD_ID_FILE = "res://build_id.txt"
const LOCAL_BUILD_STR = "local build"

func _ready():
	self.text = _read_build_id()

func _read_build_id():
	var file = File.new()
	file.open(BUILD_ID_FILE, File.READ)
	var content = file.get_as_text()
	file.close()
	return content if content else LOCAL_BUILD_STR
