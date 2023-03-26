extends Control

var transaction_popup : PackedScene = preload("res://scripts/nodes/TransactionPopup/TransactionPopup.tscn")
var stats_scene : PackedScene = preload("res://scripts/nodes/BudgetTarget/BudgetTarget.tscn")

onready var stats_box : VBoxContainer = $"%StatsContainer"
onready var currency_labels : Array = [$"%IncomeCurrencyLabel", $"%ExpensesCurrencyLabel"]
onready var calendar_button : CalendarButton = $"%CalendarButton"
onready var total_income_label : Label = $"%TotalIncomeLabel"
onready var total_expenses_label : Label = $"%TotalExpensesLabel"
onready var progress_bar : ProgressBar = $"%ProgressBar"
onready var transaction_tree : TransactionHistoryTree = $"%TransactionHistoryTree"


func _ready():
	assert(ActiveAccount.connect("transactions_changed", self, "refresh_data") == OK)
	for currency_label in currency_labels:
		currency_label.text = ActiveAccount.current_account.currency
	refresh_data()


func refresh_data() -> void:
	_setup_monthly_stats()
	_setup_budget_stats()


func _setup_monthly_stats() -> void:
	var total_income = ActiveAccount.get_total_income(calendar_button.selected_date)
	total_income_label.text = String(total_income)
	var total_expenses = ActiveAccount.get_total_expenses(calendar_button.selected_date)
	total_expenses_label.text = String(total_expenses)
	if total_income != 0:
		progress_bar.ratio = total_expenses / total_income


func _setup_budget_stats() -> void:
	for stat in stats_box.get_children():
		stats_box.remove_child(stat)
		stat.queue_free()
		
	var budget : BudgetData = UserSettings.get_linked_budget(ActiveAccount.current_filepath)
	for category in budget.categories:
		var new_stat : BudgetTarget = stats_scene.instance()
		stats_box.add_child(new_stat)
		new_stat.setup(category, calendar_button.selected_date)


func _on_NewTransactionButton_pressed():
	var transaction_dialog : TransactionDialog = transaction_popup.instance()
	add_child(transaction_dialog)
	var error = transaction_dialog.connect("confirmed", self, "_on_new_transaction_confirmed", [transaction_dialog])
	assert(error == OK)
	transaction_dialog.show()


func _on_new_transaction_confirmed(transaction_dialog : TransactionDialog):
	ActiveAccount.add_transaction(transaction_dialog.transaction_date, transaction_dialog.transaction_type, transaction_dialog.transaction_value)
	_setup_monthly_stats()
	_setup_budget_stats()
	transaction_tree.create_tree()
