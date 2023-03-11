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


func add_transaction(date : Date, type : String, value : float) -> void:
	var transaction_dic := {
		TRANSACTION_TYPE_FIELD: type,
		TRANSACTION_VALUE_FIELD: value
	}
	
	if not transactions.has(date.year()):
		transactions[date.year()] = {}
	
	if not transactions[date.year()].has(date.month()):
		transactions[date.year()][date.month()] = {}
	
	if not transactions[date.year()][date.month()].has(date.day()):
		transactions[date.year()][date.month()][date.day()] = []
	
	transactions[date.year()][date.month()][date.day()].append(transaction_dic)
