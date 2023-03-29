extends Control

onready var budget_row : PackedScene = load("res://scripts/nodes/BudgetWidget/BudgetRow.tscn")
onready var budgets_box : VBoxContainer = $VBoxContainer/Body/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	for budget in UserSettings.user_budgets:
		if budget:
			create_row(budget)


func create_row(budget : BudgetData):
	var new_row = budget_row.instance()
	budgets_box.add_child(new_row)
	new_row.setup(budget)


func _on_AddBudgetButton_pressed():
	var newbudget = UserSettings.create_budget()
	create_row(newbudget)


func _on_ScenePopButtons_pressed():
	var options = SceneManager.create_options(0)
	SceneManager.change_scene("back", options, options, SceneManager.create_general_options())
