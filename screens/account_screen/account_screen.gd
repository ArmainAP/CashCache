extends Control

onready var stats_scene = load("res://scripts/nodes/BudgetTarget/BudgetTarget.tscn")

onready var header_label = $"%HeaderLabel"
onready var stats_box = $"%StatsContainer"

func _ready():
	header_label.text = Time.get_date_string_from_system()
	var budget : BudgetData = UserSettings.get_linked_budget(ActiveAccount.current_filepath)
	for income in budget.incomes:
		var new_stat = stats_scene.instance()
		stats_box.add_child(new_stat)
		new_stat.setup(income)


func _on_CalendarButton_date_selected(date_obj : Date):
	header_label.text = date_obj.date("YYYY-MM-DD")
