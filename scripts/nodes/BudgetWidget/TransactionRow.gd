extends HBoxContainer

onready var label : LineEdit = $LineEdit

var budget_index : int
var category_index : int
var transaction_index : int

func setup(_budget_index : int, _category_index : int, _transaction_index : int):
	budget_index = _budget_index
	category_index = _category_index
	transaction_index = _transaction_index
	label.text = UserSettings.user_budgets[budget_index].categories[category_index].types[transaction_index]
