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
