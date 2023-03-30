extends VBoxContainer

onready var category_row : PackedScene = load("res://scripts/nodes/BudgetWidget/CategoryRow.tscn")
onready var categories_box : VBoxContainer = $"%Categories"
onready var label : LineEdit = $"%LineEdit"

var budget : BudgetData

func setup(_budget : BudgetData):
	budget = _budget
	label.text = budget.name
	
	for category in budget.categories:
		categories_box.add_child(_create_category(category))


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


func _on_AddCategory_pressed():
	var new_category := BudgetCategoryData.new("Category " + String(budget.categories.size()))
	budget.categories.append(new_category)
	categories_box.add_child(_create_category(new_category))
	UserSettings.save_user_data()
