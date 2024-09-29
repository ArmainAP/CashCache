extends Node
class_name FullRectDialog

@onready var parent : Window = get_parent()

func _ready():
	var viewport_error = get_viewport().connect("size_changed", Callable(self, "_on_Viewport_size_changed"))
	assert(viewport_error == OK)
	var parent_error = parent.connect("visibility_changed", Callable(self, "_on_Viewport_size_changed"))
	assert(parent_error == OK)
	_on_Viewport_size_changed()

func _on_Viewport_size_changed():
	parent.size = get_viewport().size

# Based on https://github.com/godotengine/godot/issues/41388#issuecomment-1011574759
var error_offset = 0
func _process(_delta):
	var height : int = DisplayServer.virtual_keyboard_get_height()
	if height < 0: 
		error_offset = height
