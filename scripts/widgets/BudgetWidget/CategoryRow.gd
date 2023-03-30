extends VBoxContainer

export(PackedScene) var transaction_row : PackedScene
onready var transactions_box := $"%ChildBox"
onready var line_edit : LineEdit = $"%LineEdit"
onready var color_picker : ColorPickerButton = $"%ColorPickerButton"
onready var allocation_slider = $"%AllocationInput"
onready var is_income_checkbox = $"%IsIncomeCheckBox"

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
	is_income_checkbox.pressed = category.is_income
	color_picker.color = category.color
	allocation_slider.value = category.allocation


func _create_transaction(index : int):
	var new_transaction = transaction_row.instance()
	var new_transaction_line_edit : LineEdit = new_transaction.get_node("LineEdit")
	new_transaction_line_edit.text = category.types[index]
	var error = new_transaction_line_edit.connect("text_entered", self, "_on_transaction_LineEdit_text_entered", [index])
	assert(error == OK)
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
	category.types[index] = new_text
	UserSettings.save_user_data()


func _on_ColorPickerButton_popup_closed():
	category.color = color_picker.color
	UserSettings.save_user_data()


func _on_AllocationInput_drag_ended(value_changed):
	if !value_changed:
		return
	category.allocation = allocation_slider.value
	UserSettings.save_user_data()


func _on_IsIncomeCheckBox_toggled(button_pressed):
	category.is_income = button_pressed
	UserSettings.save_user_data()
