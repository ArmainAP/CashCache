extends Control

onready var account_list : ItemList = $VBoxContainer/Body/ItemList
onready var file_dialog : FullRectDialog = $FullRectDialog
onready var password_dialog : PasswordDialog = $PasswordDialog
var import_file_path : String

func _ready():
	file_dialog.current_dir = DataManager.get_default_folder()
	for account_path in DataManager.account_paths:
		account_list.add_item(account_path)


func _on_FullRectFileDialog_file_selected(path):
	import_file_path = path


func _on_FullRectFileDialog_confirmed():
	if DataManager.import_account(import_file_path):
		account_list.add_item(import_file_path)


func _on_PasswordDialog_confirmed():
	var selected_item = account_list.get_selected_items()[0]
	if DataManager.load_account(account_list.items[selected_item], password_dialog.get_password()):
		ScreenStack.push_scene(ScreenStack.ACCOUNT_SCREEN)


func _on_ItemList_item_selected(index):
	password_dialog.popup()
