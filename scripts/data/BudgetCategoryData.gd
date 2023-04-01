extends Reference
class_name BudgetCategoryData

var name : String
var is_income : bool
var allocation : int
var color : Color
var types : Array

func _init(_name : String = "", _is_income : bool = false, _allocation : int = 100, _color : Color = Color.black, _types : Array = []):
	name = _name
	is_income = _is_income
	allocation = _allocation
	color = _color
	types = _types
