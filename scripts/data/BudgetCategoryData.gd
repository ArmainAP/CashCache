extends Reference
class_name BudgetCategoryData

var name : String
var allocation : float
var color : Color
var types : Array

func _init(_name : String = "", _allocation : float = 1, _color : Color = Color.black, _types : Array = []):
	name = _name
	allocation = _allocation
	color = _color
	types = _types
