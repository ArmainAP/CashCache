extends Reference
class_name BudgetData

class Category:
	var name : String
	var allocation : float
	var color : Color
	var types : PoolStringArray
	func _init(_name : String, _allocation : float, _color : Color, _types : PoolStringArray):
		name = _name
		allocation = _allocation
		color = _color
		types = _types

var name : String
var incomes : Array
var expenses : Array

static func default_budget() -> BudgetData:
	var new_default_budget = BudgetData.new()
	new_default_budget.name = "Default"
	new_default_budget.incomes.append(Category.new("Income", 1, Color.forestgreen,
	[
		"Salary", "Business", "Grant", "Other"
	]))
	new_default_budget.incomes.append(Category.new("Investment", 1, Color.olivedrab,
	[
		"Capital gains and dividends", "Real estate", "Royalties"
	]))
	
	new_default_budget.expenses.append(Category.new("Expense", 0.6, Color.crimson,
	[
		"Food", "Clothes", "Home", "Credit", "Health", "Transport", "Communications", "Personal care", "Taxes", "Other"
	]))
	new_default_budget.expenses.append(Category.new("Investment", 0.2, Color.olivedrab,
	[
		"Education", "Savings", "Investements"
	]))
	new_default_budget.expenses.append(Category.new("Donation", 0.1, Color.orchid,
	[
		"Gifts", "Charity"
	]))
	new_default_budget.expenses.append(Category.new("Fun", 0.1, Color.peru, 
	[
		"Joyful"
	]))
	return new_default_budget
