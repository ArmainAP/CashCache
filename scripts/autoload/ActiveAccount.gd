extends Node

const NAME_FIELD = "name"
const CURRENCY_FIELD = "currency"
const TRANSACTIONS_FIELD = "transactions"

var current_account : AccountData
var current_filepath : String


func save_account(file_path : String, password : String) -> void:
	var file = ConfigFile.new()
	file.set_value("", NAME_FIELD, current_account.name)
	file.set_value("", CURRENCY_FIELD, current_account.currency)
	file.set_value("", TRANSACTIONS_FIELD, current_account.transactions)
	file.save_encrypted_pass(file_path, password)


func load_account(file_path : String, password : String) -> bool:
	var file = ConfigFile.new()
	if file.load_encrypted_pass(file_path, password) == OK:
		current_account = AccountData.new(file.get_value("", NAME_FIELD, String()), file.get_value("", CURRENCY_FIELD, String()))
		current_account.transactions = file.get_value("", TRANSACTIONS_FIELD, Dictionary())
		current_filepath = file_path
		return true
	return false


func create_account(folder_path : String, account_data : AccountData, password : String) -> void:
	current_account = account_data
	var file_path = folder_path.plus_file(account_data.name + ".ccf")
	save_account(file_path, password)
	if load_account(file_path, password):
		assert(UserSettings.import_account(file_path))
