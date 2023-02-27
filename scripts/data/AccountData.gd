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


func add_transaction(var in_date : String, type : String, value : float) -> void:
	var transaction_dic := {
		TRANSACTION_TYPE_FIELD: type,
		TRANSACTION_VALUE_FIELD: value
	}
	if not transactions.has(in_date):
		transactions[in_date] = []
	transactions[in_date].append(transaction_dic)
