extends OptionButton

# Called when the node enters the scene tree for the first time.
func _ready():
	for budget in UserSettings.user_budgets:
		self.add_item(budget.name)
