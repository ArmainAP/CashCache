extends Reference
class_name BudgetCategoryData

var name : String
var allocation : float
var color : Color
var types : PoolStringArray

func _init(_name : String = "", _allocation : float = 0, _color : Color = Color.black, _types : PoolStringArray = []):
	name = _name
	allocation = _allocation
	color = _color
	types = _types
