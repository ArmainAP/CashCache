extends Tree


# Called when the node enters the scene tree for the first time.
func _ready():
	var transactions : Dictionary = ActiveAccount.current_account.transactions
	var budget = UserSettings.get_linked_budget(ActiveAccount.current_filepath)
	for year in transactions:
		var year_item = self.create_item()
		year_item.set_text(0, String(year))
		year_item.set_selectable(0, false)
		for month in transactions[year]:
			var month_item = self.create_item(year_item)
			month_item.set_text(0, Date.get_month_name(month))
			month_item.set_selectable(0, false)
			for day in transactions[year][month]:
				var day_item = self.create_item(month_item)
				day_item.set_text(0, String(day))
				day_item.set_selectable(0, false)
				for transaction in transactions[year][month][day]:
					var transaction_item = self.create_item(day_item)
					transaction_item.set_selectable(0, false)
					var transaction_text : String = ""
					if budget.is_income(transaction.type):
						transaction_text = "Collected " + String(transaction[AccountData.TRANSACTION_VALUE_FIELD]) + " from " + transaction[AccountData.TRANSACTION_TYPE_FIELD]
					elif budget.is_expense(transaction.type):
						transaction_text = "Spent " + String(transaction[AccountData.TRANSACTION_VALUE_FIELD]) + " on " + transaction[AccountData.TRANSACTION_TYPE_FIELD]
					else:
						transaction_text = "Transacted " + String(transaction[AccountData.TRANSACTION_VALUE_FIELD]) + " for " + transaction[AccountData.TRANSACTION_TYPE_FIELD]
					transaction_item.set_text(0, transaction_text)
