extends Control

onready var budget_row : PackedScene = load("res://scripts/nodes/BudgetWidget/BudgetRow.tscn")
onready var budgets_box : VBoxContainer = $VBoxContainer/Body/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	for index in UserSettings.user_budgets.size():
		if !UserSettings.user_budgets[index]:
			continue
		var new_row = budget_row.instance()
		budgets_box.add_child(new_row)
		new_row.setup(index)
		new_row.get_node("HBoxContainer/DeleteButton").connect("pressed", self, "_on_DeleteButton_pressed", [new_row])


func _on_AddBudgetButton_pressed():
	UserSettings.create_budget()
	var new_row = budget_row.instance()
	budgets_box.add_child(new_row)
	new_row.setup(UserSettings.user_budgets.size() - 1)


func _on_DeleteButton_pressed(new_row):
	budgets_box.remove_child(new_row)
