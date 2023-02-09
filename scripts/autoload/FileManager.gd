extends Node

const SAVE_FOLDER_NAME	= "CashCache"
const CONFIG_FILE_NAME	= "app.cfg"
const APP_SECTION_NAME	= "app"
const ACCOUNTS_KEY_NAME	= "accounts"

onready var file_checker := File.new();
onready var config_file = ConfigFile.new()
onready var load_error = config_file.load(get_config_path())

var account_paths : PoolStringArray

static func get_default_folder() -> String:
	return OS.get_system_dir(2).plus_file(SAVE_FOLDER_NAME)

static func get_config_path() -> String:
	return get_default_folder().plus_file(CONFIG_FILE_NAME)


func _ready():
	account_paths = config_file.get_value(APP_SECTION_NAME, ACCOUNTS_KEY_NAME, PoolStringArray())
	_cull_invalid_paths()


func _cull_invalid_paths() -> void:
	var is_dirty := false
	for account_path in account_paths:
		if !config_file.file_exists(account_path):
			is_dirty = true
			account_paths.remove(account_path)
	if is_dirty:
		config_file.set_value(APP_SECTION_NAME, ACCOUNTS_KEY_NAME, account_paths)
		config_file.save(get_config_path())


func get_accounts() -> PoolStringArray:
	return account_paths
