extends ConfirmationDialog
class_name AccountDialog

onready var save_location_button : Button = $"%SaveLocationButton"
onready var account_name_line_edit : LineEdit = $"%Name"
onready var account_currency_line_edit : LineEdit = $"%Currency"
onready var password_line_edit : LineEdit = $"%Password"
onready var confirm_password_line_edit : LineEdit = $"%ConfirmPassword"
onready var file_dialog : FileDialog = $"%FullRectFileDialog"
onready var budget_option_button : OptionButton = $"%BudgetOptionButton"

# Called when the node enters the scene tree for the first time.
func _ready():
	file_dialog.current_dir = UserSettings.get_default_folder()
	save_location_button.text = UserSettings.get_default_folder()
	account_name_line_edit.text = "Account" + String(UserSettings.account_paths.size() + 1)


func _on_password_text_changed(_new_text):
	self.get_ok().disabled = password_line_edit.text != confirm_password_line_edit.text


func _on_FullRectFileDialog_dir_selected(dir):
	save_location_button.text = dir


func _on_AccountDialog_confirmed():
	var account_data := AccountData.new(account_name_line_edit.text, account_currency_line_edit.text)
	assert(ActiveAccount.create_account(save_location_button.text, account_data, password_line_edit.text))
	assert(UserSettings.link_account_budget(ActiveAccount.current_filepath, budget_option_button.selected))
	var options = SceneManager.create_options(0)
	SceneManager.change_scene("account", options, options, SceneManager.create_general_options())


func edit_current_account():
	file_dialog.current_dir = ActiveAccount.current_filepath
	save_location_button.text = ActiveAccount.current_filepath if not WebFileExchange.is_web() else "Download"
	account_name_line_edit.text = ActiveAccount.current_account.name 
	account_currency_line_edit.text = ActiveAccount.current_account.currency
	password_line_edit.text = ActiveAccount.current_password
	confirm_password_line_edit.text = ActiveAccount.current_password
	var budget : BudgetData = UserSettings.get_linked_budget(ActiveAccount.current_filepath)
	var budget_index : int = UserSettings.user_budgets.find(budget)
	budget_index = 0 if budget_index < 0 else budget_index
	budget_option_button.select(budget_index)


func _on_SaveLocationButton_pressed():
	if WebFileExchange.is_web():
		WebFileExchange.download(ActiveAccount.current_filepath)
	else:
		file_dialog.show()
