extends VBoxContainer
class_name BudgetTarget

onready var currency_labels : Array = [$"%RemainingCurrencyLabel", $"%TotalCurrencyLabel"]
onready var texture_progress : TextureProgress = $"%TextureProgress"
onready var r_value_label : Label = $"%RemainingValueLabel"
onready var total_value_label : Label = $"%TotalValueLabel"
onready var progress_texture : TextureProgress = $"%TextureProgress"
onready var percentage_label : Label = $"%PercentageLabel"
onready var category_label : Label = $"%CategoryLabel"
onready var rlabel : Label = $"%RLabel"
onready var total_label : Label = $"%TotalLabel"

func _ready():
	for label in currency_labels:
		label.text = ActiveAccount.current_account.currency

func setup(category : BudgetCategoryData, date : Date, is_income : bool):
	category_label.text = category.name
	texture_progress.tint_progress = category.color
	texture_progress.tint_under = category.color / 2
	texture_progress.tint_under.a = 127
	rlabel.text = "Representing" if is_income else "Remaining"
	total_label.text = "Income" if is_income else "Expenses"
	if is_income:
		_setup_income(category, date)
	else: 
		_setup_expense(category, date)


func _setup_income(category : BudgetCategoryData, date : Date) -> void:
	var budget : float = ActiveAccount.get_total_category(date, category)
	var total : float = ActiveAccount.get_total_income(date)
	var percentage : int = int(budget / total * 100) if budget != 0 else 0
	progress_texture.value = percentage
	percentage_label.text = String(percentage) + "%"
	total_value_label.text = String(total)
	r_value_label.text = String(budget)


func _setup_expense(category : BudgetCategoryData, date : Date) -> void:
	var budget : float = ActiveAccount.get_total_income(date) * category.allocation
	var total : float = ActiveAccount.get_total_category(date, category)
	var remaining : float = budget - total
	var percentage : int = int(total / budget * 100) if budget != 0 else 0
	progress_texture.value = percentage
	percentage_label.text = String(percentage) + "%"
	total_value_label.text = String(total)
	r_value_label.text = String(remaining)
