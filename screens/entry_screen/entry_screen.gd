extends Control

onready var account_list : ItemList = $VBoxContainer/Body/ItemList
onready var file_dialog : FileDialog = $FileDialog
onready var password_dialog : PasswordDialog = $PasswordDialog
var import_file_path : String

func _ready():
	file_dialog.current_dir = UserSettings.get_default_folder()
	for account_path in UserSettings.account_paths:
		account_list.add_item(account_path)


func _import_account() -> void:
	if import_file_path.empty():
		import_file_path = file_dialog.current_path
	if UserSettings.import_account(import_file_path):
		account_list.add_item(import_file_path)


func _on_FullRectFileDialog_file_selected(path):
	import_file_path = path


func _on_PasswordDialog_confirmed():
	var selected_item = account_list.get_selected_items()[0]
	var account_path : String = account_list.get_item_text(selected_item)
	if password_dialog.should_remember_password():
		UserSettings.save_password(account_path, password_dialog.get_password())
	assert(load_account(account_path, password_dialog.get_password()))


func _on_ItemList_item_selected(_index):
	var account_path : String = account_list.get_item_text(_index)
	if UserSettings.has_password(account_path):
		if not load_account(account_path, UserSettings.get_password(account_path)):
			assert(UserSettings.erase_password(account_path))
	password_dialog.show()


func _on_ImportAccount_pressed():
	if OS.get_name() == "HTML5":
		import_file_path = yield(WebFileExchange.upload_file(), "completed")
		_import_account()
	else:
		file_dialog.show()


func load_account(account_path : String, password : String) -> bool:
	if ActiveAccount.load_account(account_path, password):
		ScreenStack.push_scene(ScreenStack.ACCOUNT_SCREEN)
		return true
	return false
