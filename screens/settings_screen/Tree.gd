extends Tree

func _ready():
	var root = self.create_item()
	root.set_text(0, "Budgets")
	new_budget("Default")


func new_budget(in_name : String) -> void:
	var budget_root = self.create_item(get_root())
	budget_root.set_text(0, in_name)
	
	var incomes = self.create_item(budget_root)
	incomes.set_text(0, "Incomes")
	
	var expenses = self.create_item(budget_root)
	expenses.set_text(0, "Expenses")

func create_item(parent: Object = null, idx: int = -1):
	print("Hello")
	return .create_item(parent, idx)
