extends ConfirmationDialog
class_name TransactionDialog

onready var transaction_option : OptionButton = $"%TransactionOptionButton"
onready var numeric_line_edit : NumericLineEdit = $"%NumericLineEdit"
onready var calendar_button : CalendarButton = $"%CalendarButton"

onready var transaction_date : Date = calendar_button.selected_date
onready var transaction_type : String = ""
onready var transaction_value : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_ok().disabled = true
	var income_types : PoolStringArray = PoolStringArray()
	var expense_types : PoolStringArray = PoolStringArray()
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
	transaction_type = transaction_option.get_item_text(0)


func _on_CalendarButton_date_selected(date):
	transaction_date = date


func _on_TransactionOptionButton_item_selected(index):
	transaction_type = transaction_option.get_item_text(index)


func _on_NumericLineEdit_text_changed(new_text):
	transaction_value = new_text.to_float()
	self.get_ok().disabled = transaction_value == 0


func set_transaction(date : Date, type : String, value : float):
	transaction_date = date
	transaction_type = type
	transaction_value = value
	calendar_button.selected_date = transaction_date
	transaction_option.selected = transaction_option.items.find(transaction_type)
	numeric_line_edit.text = String(transaction_value)
	self.get_ok().disabled = transaction_value == 0


func _on_TransactionPopup_visibility_changed():
	calendar_button.popup.hide()
