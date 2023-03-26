extends Tree
class_name TransactionHistoryTree

var edit_button_texture : Texture = preload("res://icons/outline_edit_white_48dp.png")
var delete_button_texture : Texture = preload("res://icons/delete_white_48dp.svg")
var transaction_popup : PackedScene = preload("res://scripts/nodes/TransactionPopup/TransactionPopup.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var error := self.connect("button_pressed", self, "_on_button_pressed")
	assert(error == OK)
	create_tree()


func create_tree():
	self.clear()
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
					transaction_item.set_meta("transaction", transaction)
					var date = Date.new()
					date.year = year
					date.month = month
					date.day = day
					transaction_item.set_meta("date", date)


func create_item(parent : Object = null, idx : int = -1) -> TreeItem:
	var new_item = .create_item(parent, idx)
	new_item.set_selectable(0, false)
	return new_item


func _on_button_pressed(_item: TreeItem, _column: int, _id: int):
	match(_id):
		0:
			var transaction : Dictionary = _item.get_meta("transaction")
			var date = _item.get_meta("date")
			var transaction_dialog : TransactionDialog = transaction_popup.instance()
			add_child(transaction_dialog)
			var error = transaction_dialog.connect("confirmed", self, "_on_edit_transaction_confirmed", [transaction_dialog, _item])
			assert(error == OK)
			transaction_dialog.set_transaction(date, transaction[AccountData.TRANSACTION_TYPE_FIELD], transaction[AccountData.TRANSACTION_VALUE_FIELD])
			transaction_dialog.show()
		1: 
			ActiveAccount.remove_transaction(_item.get_meta("date"), _item.get_meta("transaction"))
			create_tree()


func _on_edit_transaction_confirmed(transaction_dialog : TransactionDialog, _item):
	ActiveAccount.remove_transaction(_item.get_meta("date"), _item.get_meta("transaction"))
	ActiveAccount.add_transaction(transaction_dialog.transaction_date, transaction_dialog.transaction_type, transaction_dialog.transaction_value)
	create_tree()
