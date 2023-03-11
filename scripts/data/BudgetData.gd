extends Reference
class_name BudgetData

var name : String = ""
var incomes : Array = []
var expenses : Array = []


func _init(_name : String = ""):
	name = _name


func delete_category(in_category : BudgetCategoryData):
	var index = incomes.find(in_category)
	if index > -1:
		incomes.remove(index)
		return true
	index = expenses.find(in_category)
	if index > -1:
		expenses.remove(index)
		return true
	return false


func find_income(type : String) -> bool:
	for income in incomes:
		if income.types.find(type) > -1:
			return true
	return false


func find_expense(type : String) -> bool:
	for expense in expenses:
		if expense.types.find(type) > -1:
			return true
	return false
