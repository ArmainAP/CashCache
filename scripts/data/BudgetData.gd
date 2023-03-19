extends Reference
class_name BudgetData

var name : String = ""
var categories : Array = []


func _init(_name : String = ""):
	name = _name


func delete_category(in_category : BudgetCategoryData):
	var index = categories.find(in_category)
	if index > -1:
		categories.remove(index)
		return true
	return false


func find_category(type : String) -> bool:
	for category in categories:
		if category.types.find(type) > -1:
			return true
	return false


func get_category(type : String) -> BudgetCategoryData:
	for category in categories:
		if category.types.find(type) > -1:
			return category
	return null


func is_income(type : String) -> bool:
	var category : BudgetCategoryData = get_category(type)
	if(category):
		return category.is_income;
	return false


func is_expense(type : String) -> bool:
	var category : BudgetCategoryData = get_category(type)
	if(category):
		return not category.is_income;
	return false
