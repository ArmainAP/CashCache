extends VBoxContainer

onready var category_row : PackedScene = load("res://scripts/nodes/BudgetWidget/CategoryRow.tscn")
onready var transaction_row : PackedScene = load("res://scripts/nodes/BudgetWidget/TransactionRow.tscn")

onready var incomes_box : VBoxContainer = $Incomes
onready var expenses_box : VBoxContainer = $Expenses
onready var label : LineEdit = $HBoxContainer/LineEdit

var budget_index : int
var budget : BudgetData

func setup(_budget_index : int):
	budget_index = _budget_index
	budget = UserSettings.user_budgets[budget_index]
	label.text = budget.name
	
	for income in budget.incomes:
		incomes_box.add_child(setup_rows(income))
	
	for expense in budget.expenses:
		incomes_box.add_child(setup_rows(expense))

func setup_rows(category : BudgetCategoryData):
	var new_category = category_row.instance()
	for type in category.types:
		var new_transaction = transaction_row.instance()
		new_category.get_node("HBoxContainer2/VBoxContainer/ChildBox").add_child(new_transaction)
		new_transaction.get_node("LineEdit").text = type
	new_category.get_node("HBoxContainer2/VBoxContainer/HBoxContainer/LineEdit").text = category.name
	return new_category
