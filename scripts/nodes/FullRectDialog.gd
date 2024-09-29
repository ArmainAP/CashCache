extends Node
class_name FullRectDialog

@onready var parent : Control = get_parent()

func _ready():
	var viewport_error = get_viewport().connect("size_changed", Callable(self, "_on_Viewport_size_changed"))
	assert(viewport_error == OK)
	var parent_error = parent.connect("visibility_changed", Callable(self, "_on_Viewport_size_changed"))
	assert(parent_error == OK)
	_on_Viewport_size_changed()

func _on_Viewport_size_changed():
	parent.size = get_viewport().size
	parent.offset_left = 0
	parent.offset_top = 0
	parent.offset_right = 0
	parent.offset_bottom = 0

# Based on https://github.com/godotengine/godot/issues/41388#issuecomment-1011574759
var error_offset = 0
func _process(_delta):
	var height : int = OS.get_virtual_keyboard_height()
	if height < 0: 
		error_offset = height
	else:
		parent.offset_bottom = -(height + error_offset)
		if parent.offset_bottom > 0:
			parent.offset_bottom = 0
