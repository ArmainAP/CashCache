extends AcceptDialog
class_name PasswordDialog

onready var line_edit : LineEdit = $"%LineEdit"
onready var check_button : CheckButton = $"%CheckButton"

func get_password() -> String:
	return line_edit.text


func should_remember_password() -> bool:
	return check_button.pressed
