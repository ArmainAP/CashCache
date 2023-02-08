tool

class_name ResizableLabel

extends Label

const FONT_FALLBACK := preload("res://fonts/dynamic/Roboto-Regular.tres")
const FONT_PROPERTY := "custom_fonts/font"

export var font_size := 16 setget set_font_size
export(DynamicFont) var font_resource := FONT_FALLBACK setget set_label_font

func _init() -> void:
	set(FONT_PROPERTY, font_resource.duplicate())
	_resize()


func set_font_size(var new_font_size : int) -> void:
	font_size = new_font_size if new_font_size > 0 else 1
	_resize()


func set_label_font(var new_font_resource : DynamicFont) -> void:
	font_resource = new_font_resource if new_font_resource else FONT_FALLBACK
	set(FONT_PROPERTY, font_resource.duplicate())
	_resize()

func _resize() -> void:
	get(FONT_PROPERTY).size = font_size
