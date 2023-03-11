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


func _ready():
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
	var default_folder = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS).plus_file(SAVE_FOLDER_NAME)
	if not filesystem.dir_exists(default_folder):
		filesystem.make_dir_recursive(default_folder)
	return default_folder


func get_config_path() -> String:
	return get_default_folder().plus_file(CONFIG_FILE_NAME)


func save_user_data() -> void:
	file.set_value(APP_SECTION_NAME, ACCOUNTS_KEY_NAME, account_paths)
	file.set_value(APP_SECTION_NAME, BUDGETS_KEY_NAME, user_budgets)
	assert(file.save(get_config_path()) == OK)


func import_account(var file_path : String) -> bool:
	var found_account := account_paths.find(file_path) == -1
	if found_account:
		account_paths.append(file_path)
		save_user_data()
	return found_account


func create_budget() -> BudgetData:
	var new_budget = BudgetData.new("Budget " + String(user_budgets.size()))
	new_budget.incomes.append(BudgetCategoryData.new("Income", 1, Color.forestgreen, ["Income"]))
	new_budget.expenses.append(BudgetCategoryData.new("Expense", 1, Color.crimson, ["Expense"]))
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
	new_default_budget.incomes.append(BudgetCategoryData.new("Income", 1, Color.forestgreen,
	[
		"Salary", "Business", "Grant"
	]))
	new_default_budget.incomes.append(BudgetCategoryData.new("Investment", 1, Color.olivedrab,
	[
		"Capital gains and dividends", "Real estate", "Royalties"
	]))
	
	new_default_budget.expenses.append(BudgetCategoryData.new("Expense", 0.6, Color.crimson,
	[
		"Food", "Clothes", "Home", "Credit", "Health", "Transport", "Communications", "Personal care", "Taxes"
	]))
	new_default_budget.expenses.append(BudgetCategoryData.new("Investment", 0.2, Color.olivedrab,
	[
		"Education", "Savings", "Investements"
	]))
	new_default_budget.expenses.append(BudgetCategoryData.new("Donation", 0.1, Color.orchid,
	[
		"Gifts", "Charity"
	]))
	new_default_budget.expenses.append(BudgetCategoryData.new("Fun", 0.1, Color.peru, 
	[
		"Joyful"
	]))
	return new_default_budget
