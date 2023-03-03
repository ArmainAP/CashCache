extends VBoxContainer

onready var category_row : PackedScene = load("res://scripts/nodes/BudgetWidget/CategoryRow.tscn")

var budget_index : int

onready var categories_box = $ChildrenContainer
onready var label : LineEdit = $HBoxContainer/LineEdit

func setup(_budget_index : int):
	budget_index = _budget_index
	var budget : BudgetData = UserSettings.user_budgets[budget_index]
	label.text = budget.name
	for index in budget.categories.size():
		var new_row = category_row.instance()
		categories_box.add_child(new_row)
		new_row.setup(budget_index, index)
