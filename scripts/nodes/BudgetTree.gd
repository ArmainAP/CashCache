extends Tree

enum metadata {
	DEPTH = 0,
	DATA = 1,
	COLOR = 2
}

enum depth {
	ROOT = 0,
	BUDGET = 1,
	CATEGORY = 2,
	TRANSACTION = 3
}

enum buttons {
	COLOR = 0
	ADD = 1
	DELETE = 2
}

export(Texture) var edit_icon : Texture = preload("res://icons/outline_edit_white_48dp.png")
export(Texture) var add_icon : Texture = preload("res://icons/add_white_48dp.svg")
export(Texture) var delete_icon : Texture = preload("res://icons/delete_white_48dp.svg")
export(PackedScene) var ColorPickerPopup : PackedScene = preload("res://scripts/widgets/ColorPickerPopup/ColorPickerPopup.tscn")

onready var tree_root = create_item()

# Called when the node enters the scene tree for the first time.
func _ready():
	var pressed_error := connect("button_pressed", self, "_on_button_pressed")
	assert(pressed_error == OK)
	var edited_error = connect("item_edited", self, "_on_item_edited")
	assert(edited_error == OK)
	columns = 4
	tree_root.set_text(0, "Budgets")
	tree_root.add_button(columns-1, add_icon)
	tree_root.set_metadata(metadata.DEPTH, depth.ROOT)
	tree_root.set_selectable(0, false)
	tree_root.set_selectable(1, false)
	tree_root.set_selectable(2, false)
	for budget in UserSettings.user_budgets:
		if not budget: continue
		add_budget(budget)


func add_budget(budget : BudgetData) -> void:
	var budget_item = create_item(tree_root)
	budget_item.collapsed = true
	budget_item.set_metadata(metadata.DEPTH, depth.BUDGET)
	budget_item.set_metadata(metadata.DATA, budget)
	budget_item.set_selectable(1, false)
	budget_item.set_selectable(2, false)
	
	# text
	budget_item.set_editable(0, true)
	budget_item.set_text(0, budget.name)
	
	# buttons
	budget_item.add_button(columns-1, add_icon, buttons.ADD)
	budget_item.add_button(columns-1, delete_icon, buttons.DELETE)
	
	for category in budget.categories:
		add_category(budget_item, category)


func add_category(parent : TreeItem, category : BudgetCategoryData) -> void:
	var category_item = create_item(parent)
	category_item.collapsed = true
	category_item.set_metadata(metadata.DEPTH, depth.CATEGORY)
	category_item.set_metadata(metadata.DATA, category)
	
	var popup = ColorPickerPopup.instance()
	add_child(popup)
	var color_picker = popup.get_node("ColorPicker")
	color_picker.edit_alpha = false
	color_picker.color = category.color
	popup.connect("confirmed", self, "_on_popup_confirmed", [category_item])
	category_item.set_metadata(metadata.COLOR, popup)
	
	# text 
	category_item.set_editable(0, true)
	category_item.set_text(0, category.name)
	
	# is_income
	category_item.set_cell_mode(1, TreeItem.CELL_MODE_CHECK)
	category_item.set_checked(1, category.is_income)
	category_item.set_editable(1, true)
	category_item.set_text(1, "Is income?")
	
	# allocation
	category_item.set_cell_mode(2, TreeItem.CELL_MODE_RANGE)
	category_item.set_range(2, category.allocation)
	category_item.set_editable(2, true)
	
	# color
	category_item.set_cell_mode(3, TreeItem.CELL_MODE_CUSTOM)
	category_item.set_custom_draw(3, self, "_draw_category_color")
	
	# buttons 
	category_item.add_button(3, edit_icon, buttons.COLOR)
	category_item.add_button(columns-1, add_icon, buttons.ADD)
	category_item.add_button(columns-1, delete_icon, buttons.DELETE)
	
	for type in category.types:
		add_type(category_item, type)


func add_type(parent : TreeItem, type : String) -> void:
	var type_item = create_item(parent)
	type_item.set_metadata(metadata.DEPTH, depth.TRANSACTION)
	type_item.set_metadata(metadata.DATA, type)
	type_item.set_selectable(1, false)
	type_item.set_selectable(2, false)
	
	# text
	type_item.set_editable(0, true)
	type_item.set_text(0, type)
	
	# buttons
	type_item.add_button(columns-1, delete_icon, buttons.DELETE)


func _on_button_pressed(_item: TreeItem, _column: int, _id: int):
	match _item.get_metadata(metadata.DEPTH):
		depth.ROOT: add_budget(UserSettings.create_budget())
		depth.BUDGET: match _id:
			buttons.ADD:
				var budget : BudgetData = _item.get_metadata(metadata.DATA)
				var new_category : BudgetCategoryData = BudgetCategoryData.new("Category " + String(budget.categories.size()))
				budget.categories.append(new_category)
				UserSettings.save_user_data()
				add_category(_item, new_category)
				_item.collapsed = false
			buttons.DELETE: 
				var budget : BudgetData = _item.get_metadata(metadata.DATA)
				UserSettings.user_budgets.erase(budget)
				UserSettings.save_user_data()
				_item.free()
		depth.CATEGORY: match _id:
			buttons.COLOR:
				var popup : ColorPickerDialog = _item.get_metadata(metadata.COLOR)
				popup.popup_centered()
			buttons.ADD:
				var category : BudgetCategoryData = _item.get_metadata(metadata.DATA)
				var index : int = category.types.size()
				var new_transaction := "Type " + String(index)
				category.types.append(new_transaction)
				UserSettings.save_user_data()
				add_type(_item, new_transaction)
				_item.collapsed = false
			buttons.DELETE:
				var budget : BudgetData = _item.get_parent().get_metadata(metadata.DATA)
				var category : BudgetCategoryData = _item.get_metadata(metadata.DATA)
				if budget.delete_category(category):
					_item.free()
		depth.TRANSACTION:
			var category : BudgetCategoryData = _item.get_parent().get_metadata(metadata.DATA)
			var type : String = _item.get_text(0)
			var index : int = category.types.find(type)
			if index > -1:
				category.types.remove(index)
				UserSettings.save_user_data()
				_item.free()


func _on_item_edited() -> void:
	var edited_item = get_edited()
	match edited_item.get_metadata(metadata.DEPTH):
		depth.BUDGET:
			var budget : BudgetData = edited_item.get_metadata(metadata.DATA)
			budget.name = edited_item.get_text(0)
		depth.CATEGORY:
			var category : BudgetCategoryData = edited_item.get_metadata(metadata.DATA)
			category.name = edited_item.get_text(0)
			category.is_income = edited_item.is_checked(1)
			category.allocation = edited_item.get_range(2)
		depth.TRANSACTION:
			var category : BudgetCategoryData = edited_item.get_parent().get_metadata(metadata.DATA)
			var old_text : String = edited_item.get_metadata(metadata.DATA)
			var index : int = category.types.find(old_text)
			if index > -1:
				category.types[index] = edited_item.get_text(0)
	UserSettings.save_user_data()


func _draw_category_color(item : TreeItem, rect : Rect2):
	var category : BudgetCategoryData = item.get_metadata(metadata.DATA)
	draw_rect(rect, category.color)


func _on_popup_confirmed(category_item : TreeItem) -> void:
	var color_picker : ColorPicker = category_item.get_metadata(metadata.COLOR).get_node("ColorPicker")
	var category : BudgetCategoryData = category_item.get_metadata(metadata.DATA)
	category.color = color_picker.color
	UserSettings.save_user_data()
