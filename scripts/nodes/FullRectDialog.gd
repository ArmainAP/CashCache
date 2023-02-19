extends Popup
class_name FullRectDialog

func _ready():
	get_viewport().connect("size_changed", self, "_on_Viewport_size_changed")
	_on_Viewport_size_changed()


func _on_popup_button_pressed():
	popup()
	_on_Viewport_size_changed()

func _on_Viewport_size_changed():
	rect_size = get_viewport().size
	margin_left = 0
	margin_top = 0
	margin_right = 0
	margin_bottom = 0
