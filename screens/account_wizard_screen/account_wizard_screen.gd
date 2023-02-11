extends Control

onready var confirm_button : Button = $VBoxContainer/Header/HBoxContainer/ConfirmButton
onready var save_location_button : Button = $VBoxContainer/Body/VBoxContainer/SaveLocationButton
onready var account_name_line_edit : LineEdit = $VBoxContainer/Body/VBoxContainer/VBoxContainer/HBoxContainer2/LineEdit
onready var account_currency_line_edit : LineEdit = $VBoxContainer/Body/VBoxContainer/VBoxContainer/HBoxContainer3/LineEdit
onready var password_line_edit : LineEdit = $VBoxContainer/Body/VBoxContainer/VBoxContainer/VBoxContainer2/Password
onready var confirm_password_line_edit : LineEdit = $VBoxContainer/Body/VBoxContainer/VBoxContainer/VBoxContainer2/ConfirmPassword
onready var file_dialog : FileDialog = $FullRectFileDialog

# Called when the node enters the scene tree for the first time.
func _ready():
	file_dialog.current_dir = DataManager.get_default_folder()
	save_location_button.text = DataManager.get_default_folder()
	account_name_line_edit.text = "Account" + String(DataManager.account_paths.size() + 1)


func _on_password_text_changed(new_text):
	confirm_button.disabled = password_line_edit.text != confirm_password_line_edit.text


func _on_ConfirmButton_pressed():	
	var account_data := AccountData.new()
	account_data.name = account_name_line_edit.text
	account_data.currency = account_currency_line_edit.text
	DataManager.create_account(save_location_button.text, account_data, password_line_edit.text)


func _on_FullRectFileDialog_dir_selected(dir):
	save_location_button.text = dir
