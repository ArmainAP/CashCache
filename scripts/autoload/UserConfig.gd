extends Node

const APP_SECTION_NAME = "app"

onready var config_file = ConfigFile.new()
onready var load_error = config_file.load(OS.get_user_data_dir())
