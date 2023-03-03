extends Node

const SAVE_FOLDER_NAME = "CashCache"
const CONFIG_FILE_NAME = "app.cfg"
const APP_SECTION_NAME = "app"
const ACCOUNTS_KEY_NAME = "accounts"
const BUDGETS_KEY_NAME = "budgets"

onready var filesystem = Directory.new()
onready var file := ConfigFile.new()
onready var file_error := file.load(get_config_path())
onready var account_paths : PoolStringArray = file.get_value(APP_SECTION_NAME, ACCOUNTS_KEY_NAME, PoolStringArray())
onready var user_budgets : Array = file.get_value(APP_SECTION_NAME, BUDGETS_KEY_NAME, [])

func _ready():
	_cull_invalid_paths()


func _cull_invalid_paths() -> void:
	var indices : PoolIntArray
	for idx in account_paths.size():
		if !filesystem.file_exists(account_paths[idx]):
			indices.append(idx)
	if indices.size() > 0:
		for idx in indices:
			account_paths.remove(idx)
		save_user_data()


func get_default_folder() -> String:
	var default_folder = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS).plus_file(SAVE_FOLDER_NAME)
	if not filesystem.dir_exists(default_folder):
		filesystem.make_dir_recursive(default_folder)
	return default_folder


func get_config_path() -> String:
	return get_default_folder().plus_file(CONFIG_FILE_NAME)


func save_user_data() -> void:
	file.set_value(APP_SECTION_NAME, ACCOUNTS_KEY_NAME, account_paths)
	file.save(get_config_path())


func import_account(var file_path : String) -> bool:
	var found_account := account_paths.find(file_path) == -1
	if found_account:
		account_paths.append(file_path)
		save_user_data()
	return found_account
