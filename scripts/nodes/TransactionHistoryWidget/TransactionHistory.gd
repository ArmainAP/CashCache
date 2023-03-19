extends ScrollContainer

onready var transaction_box : VBoxContainer = $VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	var transactions : Dictionary = ActiveAccount.current_account.transactions
	var budget = UserSettings.get_linked_budget(ActiveAccount.current_filepath)
	for year in transactions:
		for month in transactions[year]:
			for day in transactions[year][month]:
				add_label(String(year) + "-" + String(month) + "-" + String(day))
				for transaction in transactions[year][month][day]:
					if budget.is_income(transaction.type):
						add_label("Collected " + String(transaction[AccountData.TRANSACTION_VALUE_FIELD]) + " from " + transaction[AccountData.TRANSACTION_TYPE_FIELD])
					elif budget.is_expense(transaction.type):
						add_label("Spent " + String(transaction[AccountData.TRANSACTION_VALUE_FIELD]) + " on " + transaction[AccountData.TRANSACTION_TYPE_FIELD])
					else:
						add_label("Transacted " + String(transaction[AccountData.TRANSACTION_VALUE_FIELD]) + " for " + transaction[AccountData.TRANSACTION_TYPE_FIELD])

func add_label(message : String) -> void:
	var new_label = Label.new()
	new_label.text = message
	transaction_box.add_child(new_label)
