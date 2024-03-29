extends Node

const SAVE_FOLDER_NAME = "CashCache"
const CONFIG_FILE_NAME = "app.cfg"
const APP_SECTION_NAME = "app"
const ACCOUNTS_KEY_NAME = "accounts"
const BUDGETS_KEY_NAME = "budgets"
const BUDGET_LINKS_KEY_NAME = "budget_links"

onready var filesystem = Directory.new()
onready var file := ConfigFile.new()
onready var file_error := file.load(get_config_path())
onready var account_paths : PoolStringArray = file.get_value(APP_SECTION_NAME, ACCOUNTS_KEY_NAME, PoolStringArray())
onready var user_budgets : Array = file.get_value(APP_SECTION_NAME, BUDGETS_KEY_NAME, [default_budget()])
onready var budget_links : Dictionary = file.get_value(APP_SECTION_NAME, BUDGET_LINKS_KEY_NAME, {})

var _saved_passwords = {}

func _ready():
	if OS.get_name() == "Android":
		print(OS.request_permissions())
	if file_error == OK:
		_cull_invalid_paths()
		_cull_invalid_budgets()


func _cull_invalid_paths() -> void:
	var indices : PoolIntArray = []
	for idx in account_paths.size():
		if !filesystem.file_exists(account_paths[idx]):
			indices.append(idx)
	if indices.size() > 0:
		for idx in indices:
			account_paths.remove(idx)
		save_user_data()


func _cull_invalid_budgets() -> void:
	var indices : PoolIntArray = []
	for idx in user_budgets.size():
		if user_budgets[idx] == null:
			indices.append(idx)
	if indices.size() == user_budgets.size():
		user_budgets = [default_budget()]
	elif indices.size() > 0:
		for idx in indices:
			user_budgets.remove(idx)
		save_user_data()


func get_default_folder() -> String:
	var default_folder = "/" if WebFileExchange.is_web() else OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	default_folder = default_folder.plus_file(SAVE_FOLDER_NAME)
	if not filesystem.dir_exists(default_folder):
		filesystem.make_dir_recursive(default_folder)
	return default_folder


func get_config_path() -> String:
	return get_default_folder().plus_file(CONFIG_FILE_NAME)


func save_user_data() -> void:
	file.set_value(APP_SECTION_NAME, ACCOUNTS_KEY_NAME, account_paths)
	file.set_value(APP_SECTION_NAME, BUDGETS_KEY_NAME, user_budgets)
	var error = file.save(get_config_path()) 
	assert(error == OK)


func import_account(var file_path : String) -> bool:
	var found_account := account_paths.find(file_path) == -1
	if found_account:
		account_paths.append(file_path)
		save_user_data()
	return found_account


func create_budget() -> BudgetData:
	var new_budget = BudgetData.new("Budget " + String(user_budgets.size()))
	new_budget.categories.append(BudgetCategoryData.new("Income", true, 100, Color.forestgreen, ["Income"]))
	new_budget.categories.append(BudgetCategoryData.new("Expense", false, 100, Color.crimson, ["Expense"]))
	user_budgets.append(new_budget)
	save_user_data()
	return new_budget


func link_account_budget(account_path : String, budget_index : int) -> bool:
	if budget_index < 0:
		return false
	budget_links[account_path] = budget_index
	return true


func get_linked_budget(account_path : String) -> BudgetData:
	if budget_links.has(account_path):
		var budget_index = budget_links[account_path]
		if budget_index < user_budgets.size():
			return user_budgets[budget_index]
	return default_budget()


static func default_budget() -> BudgetData:
	var new_default_budget = BudgetData.new("Default")
	new_default_budget.categories.append(BudgetCategoryData.new("Income", true, 100, Color.forestgreen,
	[
		"Salary", "Business", "Grant"
	]))
	new_default_budget.categories.append(BudgetCategoryData.new("Investment", true, 100, Color.olivedrab,
	[
		"Capital gains and dividends", "Real estate", "Royalties"
	]))
	
	new_default_budget.categories.append(BudgetCategoryData.new("Expense", false, 60, Color.crimson,
	[
		"Food", "Clothes", "Home", "Credit", "Health", "Transport", "Communications", "Personal care", "Taxes"
	]))
	new_default_budget.categories.append(BudgetCategoryData.new("Investment", false, 20, Color.olivedrab,
	[
		"Education", "Savings", "Investements"
	]))
	new_default_budget.categories.append(BudgetCategoryData.new("Donation", false, 10, Color.orchid,
	[
		"Gifts", "Charity"
	]))
	new_default_budget.categories.append(BudgetCategoryData.new("Fun", false, 10, Color.peru, 
	[
		"Joyful"
	]))
	return new_default_budget


func save_password(account_path : String, account_password : String) -> void:
	_saved_passwords[account_path] = account_password


func has_password(account_path : String) -> bool:
	return _saved_passwords.has(account_path)


func erase_password(account_path : String) -> bool:
	return _saved_passwords.erase(account_path)


func get_password(account_path : String) -> String:
	return _saved_passwords[account_path]
