extends Tree

var edit_button_texture : Texture = preload("res://icons/outline_edit_white_48dp.png")
var delete_button_texture : Texture = preload("res://icons/delete_white_48dp.svg")

# Called when the node enters the scene tree for the first time.
func _ready():
	var error := self.connect("button_pressed", self, "_on_button_pressed")
	assert(error == OK)
	var transactions : Dictionary = ActiveAccount.current_account.transactions
	var budget = UserSettings.get_linked_budget(ActiveAccount.current_filepath)
	for year in transactions:
		var year_item = self.create_item()
		year_item.set_text(0, String(year))
		for month in transactions[year]:
			var month_item = self.create_item(year_item)
			month_item.set_text(0, Date.get_month_name(month))
			for day in transactions[year][month]:
				var day_item = self.create_item(month_item)
				day_item.set_text(0, String(day))
				for transaction in transactions[year][month][day]:
					var transaction_item = self.create_item(day_item)
					var transaction_text : String = ""
					if budget.is_income(transaction.type):
						transaction_text = "Collected " + String(transaction[AccountData.TRANSACTION_VALUE_FIELD]) + " from " + transaction[AccountData.TRANSACTION_TYPE_FIELD]
					elif budget.is_expense(transaction.type):
						transaction_text = "Spent " + String(transaction[AccountData.TRANSACTION_VALUE_FIELD]) + " on " + transaction[AccountData.TRANSACTION_TYPE_FIELD]
					else:
						transaction_text = "Transacted " + String(transaction[AccountData.TRANSACTION_VALUE_FIELD]) + " for " + transaction[AccountData.TRANSACTION_TYPE_FIELD]
					transaction_item.set_text(0, transaction_text)
					transaction_item.add_button(0, edit_button_texture)
					transaction_item.add_button(0, delete_button_texture)
					transaction_item.set_meta("year", year)
					transaction_item.set_meta("month", month)
					transaction_item.set_meta("day", day)
					transaction_item.set_meta("transaction", transaction)


func create_item(parent : Object = null, idx : int = -1) -> TreeItem:
	var new_item = .create_item(parent, idx)
	new_item.set_selectable(0, false)
	return new_item


func _on_button_pressed(_item: TreeItem, _column: int, _id: int):
	match(_id):
		1: 
			var date = Date.new()
			date.year = _item.get_meta("year")
			date.month = _item.get_meta("month")
			date.day = _item.get_meta("day")
			ActiveAccount.remove_transaction(date, _item.get_meta("transaction"))
			var item_day = _remove_child_from_parent(_item)
			if not ActiveAccount.current_account.has_date_data(date, 2):
				var item_month = _remove_child_from_parent(item_day)
				if not ActiveAccount.current_account.has_date_data(date, 1):
					var item_year = _remove_child_from_parent(item_month)
					if not ActiveAccount.current_account.has_date_data(date, 0):
						item_year.free()


func _remove_child_from_parent(item : TreeItem) -> TreeItem:
	var parent = item.get_parent()
	parent.remove_child(item)
	item.free()
	return parent
