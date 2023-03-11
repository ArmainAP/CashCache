extends HBoxContainer

onready var currency_labels = [$"%RemainingCurrencyLabel", $"%TotalCurrencyLabel"]
onready var texture_progress = $"%TextureProgress"

func _ready():
	for label in currency_labels:
		label.text = ActiveAccount.current_account.currency

func setup(budget : BudgetCategoryData):
	texture_progress.tint_progress = budget.color
	texture_progress.tint_under = budget.color
	texture_progress.tint_under.a = 127
