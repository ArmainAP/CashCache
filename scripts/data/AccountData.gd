extends Reference
class_name AccountData

const NAME_FIELD = "name"
const CURRENCY_FIELD = "currency"
const TRANSACTIONS_FIELD = "transactions"
const TRANSACTION_TYPE_FIELD = "type"
const TRANSACTION_VALUE_FIELD = "value"

var name : String
var currency : String
var transactions : Dictionary

func from_dictionary(var dictionary : Dictionary) -> AccountData:
	self.name = dictionary.get(NAME_FIELD, "")
	self.currency = dictionary.get(CURRENCY_FIELD, "")
	self.transactions = dictionary.get(TRANSACTIONS_FIELD, "")
	return self


func to_dictionary() -> Dictionary:
	return {
		NAME_FIELD: self.name,
		CURRENCY_FIELD: self.currency,
		TRANSACTIONS_FIELD: self.transactions
	}

func save_account(var file_path : String, var password : String) -> void:
	var new_file = File.new()
	new_file.open_encrypted_with_pass(file_path, File.WRITE, password)
	var account_json := JSON.print(self.to_dictionary())
	new_file.store_string(account_json)
	new_file.close()

func add_transaction(var in_date : String, type : String, value : float) -> void:
	var transaction_dic := {
		TRANSACTION_TYPE_FIELD: type,
		TRANSACTION_VALUE_FIELD: value
	}
	if not transactions.has(in_date):
		transactions[in_date] = []
	transactions[in_date].append(transaction_dic)
