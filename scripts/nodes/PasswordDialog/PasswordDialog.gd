extends FullRectDialog
class_name PasswordDialog

onready var line_edit = $MarginContainer/VBoxContainer/LineEdit

func get_password() -> String:
	return line_edit.text
