extends Popup
class_name FullRectDialog

func _ready():
	var error = get_viewport().connect("size_changed", self, "_on_Viewport_size_changed")
	assert(error == OK)
	_on_Viewport_size_changed()


func show():
	popup()
	_on_Viewport_size_changed()

func _on_Viewport_size_changed():
	rect_size = get_viewport().size
	margin_left = 0
	margin_top = 0
	margin_right = 0
	margin_bottom = 0
