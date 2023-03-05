extends VBoxContainer

onready var transaction_row : PackedScene = load("res://scripts/nodes/BudgetWidget/TransactionRow.tscn")
onready var transactions_box := $HBoxContainer2/VBoxContainer/HBoxContainer4/ChildBox
onready var line_edit := $HBoxContainer2/VBoxContainer/HBoxContainer/LineEdit

var budget : BudgetData
var category : BudgetCategoryData

func setup(_budget : BudgetData, _category : BudgetCategoryData):
	budget = _budget
	category = _category


func _ready():
	for index in category.types.size():
		var new_transaction = _create_transaction(index)
		transactions_box.add_child(new_transaction)
	line_edit.text = category.name


func _create_transaction(index : int):
	var new_transaction = transaction_row.instance()
	var new_transaction_line_edit : LineEdit = new_transaction.get_node("LineEdit")
	new_transaction_line_edit.text = category.types[index]
	new_transaction_line_edit.connect("text_entered", self, "_on_transaction_LineEdit_text_entered", [index])
	new_transaction.get_node("DeleteButton").connect("pressed", self, "_on_transaction_DeleteButton_pressed", [new_transaction])
	return new_transaction


func _on_AddButton_pressed():
	var index : int = category.types.size()
	var new_transaction := "Type " + String(index)
	category.types.append(new_transaction)
	transactions_box.add_child(_create_transaction(index))
	UserSettings.save_user_data()


func _on_DeleteButton_pressed():
	if budget.delete_category(category):
		UserSettings.save_user_data()
		get_parent().remove_child(self)
		self.queue_free()


func _on_LineEdit_text_entered(new_text):
	category.name = new_text
	UserSettings.save_user_data()


func _on_transaction_DeleteButton_pressed(new_transaction):
	var type : String = new_transaction.get_node("LineEdit").text
	var index : int = category.types.find(type)
	if index > -1:
		category.types.remove(index)
		UserSettings.save_user_data()
		transactions_box.remove_child(new_transaction)
		new_transaction.queue_free()


func _on_transaction_LineEdit_text_entered(new_text, index):
	print(category.types[index])
	category.types[index] = new_text
	print(category.types[index])
	UserSettings.save_user_data()
