extends Control

onready var stats_scene = preload("res://scripts/nodes/BudgetTarget/BudgetTarget.tscn")

onready var header_label : Label = $"%HeaderLabel"
onready var stats_box : VBoxContainer = $"%StatsContainer"
onready var currency_labels : Array = [$"%IncomeCurrencyLabel", $"%ExpensesCurrencyLabel"]
onready var calendar_button : CalendarButton = $"%CalendarButton"
onready var total_income_label : Label = $"%TotalIncomeLabel"
onready var total_expenses_label : Label = $"%TotalExpensesLabel"
onready var progress_bar : ProgressBar = $"%ProgressBar"

func _ready():
	header_label.text = Time.get_date_string_from_system()
	for currency_label in currency_labels:
		currency_label.text = ActiveAccount.current_account.currency
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
	var budget : BudgetData = UserSettings.get_linked_budget(ActiveAccount.current_filepath)
	for income in budget.incomes:
		var new_stat : BudgetTarget = stats_scene.instance()
		stats_box.add_child(new_stat)
		new_stat.setup(income, calendar_button.selected_date, true)
	for expense in budget.expenses:
		var new_stat : BudgetTarget = stats_scene.instance()
		stats_box.add_child(new_stat)
		new_stat.setup(expense, calendar_button.selected_date, false)


func _on_CalendarButton_date_selected(date_obj : Date):
	header_label.text = date_obj.date("YYYY-MM-DD")
