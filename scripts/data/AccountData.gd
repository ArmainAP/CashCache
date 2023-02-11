class_name AccountData

const NAME_FIELD = "name"
const CURRENCY_FIELD = "currency"
const TRANSACTIONS_FIELD = "transactions"

var name : String
var currency : String
var transactions : Array


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
