extends Control

onready var transaction_option : OptionButton = $"%TransactionOptionButton"
onready var numeric_line_edit : NumericLineEdit = $"%NumericLineEdit"
onready var calendar_button : CalendarButton = $"%CalendarButton"
onready var confirm_button : Button = $"%ConfirmButton"

var income_types : PoolStringArray
var expense_types : PoolStringArray

func _ready():
	var budget = UserSettings.get_linked_budget(ActiveAccount.current_filepath)
	for category in budget.categories:
		if category.is_income:
			income_types.append_array(category.types)
		else:
			expense_types.append_array(category.types)
	for expense in expense_types:
		transaction_option.add_item(expense)
	for income in income_types:
		transaction_option.add_item(income)


func _on_TransactionOptionButton_item_selected(index):
	var text : String = transaction_option.get_item_text(index)
	var is_income = true if income_types.find(text) > -1 else false
	var value = numeric_line_edit.text.to_float()
	if is_income:
		if value < 0:
			numeric_line_edit.text = String(-value)
	else:
		if value > 0:
			numeric_line_edit.text = String(-value)


func _on_ConfirmButton_pressed():
	ActiveAccount.add_transaction(calendar_button.selected_date, transaction_option.get_item_text(transaction_option.selected), numeric_line_edit.text.to_float())
	ScreenStack.remove_scene(1)
	ScreenStack.remove_scene(1)


func _on_NumericLineEdit_text_changed(new_text):
	confirm_button.disabled = new_text.to_int() == 0
