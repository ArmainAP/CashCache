extends Node

const NAME_FIELD = "name"
const CURRENCY_FIELD = "currency"
const TRANSACTIONS_FIELD = "transactions"

var current_account : AccountData
var current_filepath : String
var current_password : String


static func save_account(account : AccountData, file_path : String, password : String) -> bool:
	var file = ConfigFile.new()
	file.set_value("", NAME_FIELD, account.name)
	file.set_value("", CURRENCY_FIELD, account.currency)
	file.set_value("", TRANSACTIONS_FIELD, account.transactions)
	return file.save_encrypted_pass(file_path, password) == OK


func load_account(file_path : String, password : String) -> bool:
	var file = ConfigFile.new()
	if file.load_encrypted_pass(file_path, password) == OK:
		current_account = AccountData.new(file.get_value("", NAME_FIELD, String()), file.get_value("", CURRENCY_FIELD, String()))
		current_account.transactions = file.get_value("", TRANSACTIONS_FIELD, Dictionary())
		current_filepath = file_path
		current_password = password
		return true
	return false


func create_account(folder_path : String, account_data : AccountData, password : String) -> bool:
	var file_path = folder_path.plus_file(account_data.name + ".ccf")
	if not save_account(account_data, file_path, password):
		return false
	if load_account(file_path, password):
		return UserSettings.import_account(file_path)
	return false


func add_transaction(date : Date, type : String, value : float) -> void:
	current_account.add_transaction(date, type, value)
	assert(save_account(current_account, current_filepath, current_password))

func remove_transaction(date : Date, transaction) -> void:
	assert(current_account.remove_transaction(date, transaction))
	assert(save_account(current_account, current_filepath, current_password))


func get_total_income(date : Date) -> float:
	if not current_account.has_date_data(date, 1):
		return 0.0
	var value : float = 0.0
	var monthly_data : Dictionary = current_account.transactions[date.year][date.month]
	var budget : BudgetData = UserSettings.get_linked_budget(current_filepath)
	for key in monthly_data.keys():
		for transaction in monthly_data[key]:
			if budget.is_income(transaction[AccountData.TRANSACTION_TYPE_FIELD]):
				value += transaction[AccountData.TRANSACTION_VALUE_FIELD]
	return value


func get_total_expenses(date : Date) -> float:
	if not current_account.has_date_data(date, 1):
		return 0.0
	var value : float = 0.0
	var monthly_data : Dictionary = current_account.transactions[date.year][date.month]
	var budget : BudgetData = UserSettings.get_linked_budget(current_filepath)
	for key in monthly_data.keys():
		for transaction in monthly_data[key]:
			if budget.is_expense(transaction[AccountData.TRANSACTION_TYPE_FIELD]):
				value += transaction[AccountData.TRANSACTION_VALUE_FIELD]
	return value

func get_total_category(date : Date, category : BudgetCategoryData) -> float:
	if not current_account.has_date_data(date, 1):
		return 0.0
	var value : float = 0.0
	var monthly_data : Dictionary = current_account.transactions[date.year][date.month]
	for key in monthly_data.keys():
		for transaction in monthly_data[key]:
			if category.types.find(transaction[AccountData.TRANSACTION_TYPE_FIELD]) > -1:
				value += transaction[AccountData.TRANSACTION_VALUE_FIELD]
	return value
