extends Node

const NAME_FIELD = "name"
const CURRENCY_FIELD = "currency"
const TRANSACTIONS_FIELD = "transactions"

var current_account : AccountData


func save_account(file_path : String, password : String) -> void:
	var file = ConfigFile.new()
	file.set_value("", NAME_FIELD, current_account.name)
	file.set_value("", CURRENCY_FIELD, current_account.currency)
	file.set_value("", TRANSACTIONS_FIELD, current_account.transactions)
	file.save_encrypted_pass(file_path, password)


func load_account(var file_path : String, var password : String) -> bool:
	var file = ConfigFile.new()
	if file.load_encrypted_pass(file_path, password) == OK:
		current_account = AccountData.new()
		current_account.name = file.get_value("", NAME_FIELD, String())
		current_account.currency = file.get_value("", CURRENCY_FIELD, String())
		current_account.transactions = file.get_value("", TRANSACTIONS_FIELD, Dictionary())
		return true
	return false


func create_account(var folder_path : String, var account_data : AccountData, var password : String) -> void:
	current_account = account_data
	var file_path = folder_path.plus_file(account_data.name + ".ccf")
	save_account(file_path, password)
	if load_account(file_path, password):
		UserSettings.import_account(file_path)
