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

static func get_transaction_dictionary(type : String = "", value : float = 0) -> Dictionary:
	return {
		TRANSACTION_TYPE_FIELD: type,
		TRANSACTION_VALUE_FIELD: value
	}


func _init(_name : String = "", _currency : String = ""):
	name = _name
	currency = _currency


func add_transaction(date : Date, type : String, value : float) -> void:
	ensure_date_exists(date)
	var transaction : Dictionary = get_transaction_dictionary(type, value)
	transactions[date.year][date.month][date.day].append(transaction)


func remove_transaction(date : Date, transaction) -> bool:
	if not has_date_data(date, 2): return false
	transactions[date.year][date.month][date.day].erase(transaction)
	if transactions[date.year][date.month][date.day].size() == 0:
		transactions[date.year][date.month].erase(date.day)
	if transactions[date.year][date.month].size() == 0:
		transactions[date.year].erase(date.month)
	if transactions[date.year].size() == 0:
		var erase_success = transactions.erase(date.year)
		assert(erase_success)
	return true


func has_year_data(year : int) -> bool:
	return transactions.has(year)


func has_month_data(year : int, month : int) -> bool:
	if has_year_data(year):
		return transactions[year].has(month)
	return false


func has_day_data(year : int, month : int, day : int) -> bool:
	if has_year_data(year):
		if has_month_data(year, month):
			return transactions[year][month].has(day)
	return false


func has_date_data(date : Date, level : int) -> bool:
	match(level):
		0: return has_year_data(date.year)
		1: return has_month_data(date.year, date.month)
		2: return has_day_data(date.year, date.month, date.day)
	return false


func ensure_date_exists(date : Date) -> void:
	if not transactions.has(date.year): transactions[date.year] = {}
	if not transactions[date.year].has(date.month): transactions[date.year][date.month] = {}
	if not transactions[date.year][date.month].has(date.day): transactions[date.year][date.month][date.day] = []
