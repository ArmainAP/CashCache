extends Reference
class_name Date


var day : int = 21
var month : int = 8
var year : int = 1999


func _init():
	var date : Dictionary = Time.get_date_dict_from_system()
	self.day = date["day"]
	self.month = date["month"]
	self.year = date["year"]


func decrement_month():
	month -= 1
	if(month < 1):
		month = 12
		year -= 1


func increment_month():
	month += 1
	if(month > 12):
		month = 1
		year += 1


# Supported Date Formats:
# DD : Two digit day of month
# MM : Two digit month
# YY : Two digit year
# YYYY : Four digit year
func date(date_format = "YYYY-MM-DD") -> String:
	if("DD".is_subsequence_of(date_format)):
		date_format = date_format.replace("DD", str(day).pad_zeros(2))
	if("MM".is_subsequence_of(date_format)):
		date_format = date_format.replace("MM", str(month).pad_zeros(2))
	if("YYYY".is_subsequence_of(date_format)):
		date_format = date_format.replace("YYYY", str(year))
	elif("YY".is_subsequence_of(date_format)):
		date_format = date_format.replace("YY", str(year).substr(2,3))
	return date_format
