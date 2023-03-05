extends VBoxContainer

export(NodePath) var income_box_path : NodePath
export(NodePath) var expenses_box_path : NodePath
export(NodePath) var label_path : NodePath

onready var category_row : PackedScene = load("res://scripts/nodes/BudgetWidget/CategoryRow.tscn")
onready var incomes_box : VBoxContainer = get_node(income_box_path)
onready var expenses_box : VBoxContainer = get_node(expenses_box_path)
onready var label : LineEdit = get_node(label_path)

var budget : BudgetData

func setup(_budget : BudgetData):
	budget = _budget
	label.text = budget.name
	
	for income in budget.incomes:
		incomes_box.add_child(_create_category(income))
	
	for expense in budget.expenses:
		expenses_box.add_child(_create_category(expense))


func _create_category(category : BudgetCategoryData):
	var new_category = category_row.instance()
	new_category.setup(budget, category)
	return new_category


func _on_LineEdit_text_entered(new_text : String):
	budget.name = new_text
	UserSettings.save_user_data()


func _on_DeleteButton_pressed():
	UserSettings.user_budgets.erase(budget)
	UserSettings.save_user_data()
	get_parent().remove_child(self)
	self.queue_free()


func _on_AddIncomeCategory_pressed():
	var new_category := BudgetCategoryData.new("Category " + String(budget.incomes.size()))
	budget.incomes.append(new_category)
	incomes_box.add_child(_create_category(new_category))
	UserSettings.save_user_data()


func _on_AddExpenseCategory_pressed():
	var new_category := BudgetCategoryData.new("Category " + String(budget.expenses.size()))
	budget.expenses.append(new_category)
	expenses_box.add_child(_create_category(new_category))
	UserSettings.save_user_data()
