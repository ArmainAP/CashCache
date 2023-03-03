extends VBoxContainer
class_name CategoryRow

onready var transaction_row : PackedScene = load("res://scripts/nodes/BudgetWidget/TransactionRow.tscn")

var budget_index : int
var category_index : int

onready var transactions_box = $ChildrenContainer
onready var label = $HBoxContainer/LineEdit

func setup(_budget_index : int, _category_index : int):
	budget_index = _budget_index
	category_index = _category_index
	var category : BudgetCategoryData = UserSettings.user_budgets[budget_index].categories[category_index]
	label.text = category.name
	for index in category.types.size():
		var new_row = transaction_row.instance()
		transactions_box.add_child(new_row)
		new_row.setup(budget_index, category_index, index)
