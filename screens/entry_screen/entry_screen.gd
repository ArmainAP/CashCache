extends Control

onready var account_list : ItemList = $VBoxContainer/Body/ItemList
var import_file_path : String

func _ready():
	for account_path in DataManager.account_paths:
		account_list.add_item(account_path)


func _on_FullRectFileDialog_file_selected(path):
	import_file_path = path


func _on_FullRectFileDialog_confirmed():
	if DataManager.import_account(import_file_path):
		account_list.add_item(import_file_path)
