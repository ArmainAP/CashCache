extends Button
class_name CalendarButton

signal date_selected(date)

onready var popup : Popup = $"%Popup"
onready var popup_panel : PanelContainer = $"%PanelContainer"
onready var title : Label = $"%Label"
onready var days_grid : GridContainer = $"%GridContainer"

onready var selected_date := Date.new()

func _ready():
	var error := connect("visibility_changed", self, "_on_visibility_changed")
	assert(error == OK)
	for child in days_grid.get_children():
		if child is Button:
			child.connect("pressed", self, "grid_button_pressed", [child])
	refresh_data()


func _process(_delta):
	restrict_popup_inside_screen()


func _toggled(is_pressed):
	if(is_pressed): 
		popup.show()
		restrict_popup_inside_screen()
	else: 
		popup.hide()
	set_process(is_pressed)


func restrict_popup_inside_screen():
	var popup_x_size = popup_panel.get_size().x
	var popup_y_size = popup_panel.get_size().y
	var calendar_icon_x_pos = get_global_position().x
	var calendar_icon_y_pos = get_global_position().y
	var calendar_icon_x_size = get_size().x
	var calendar_icon_y_size = get_size().y
	var window_size_x = OS.get_window_size().x
	var window_size_y = OS.get_window_size().y
	
	var pos_x = 0
	if(window_size_x > (popup_x_size + calendar_icon_x_size/2)):
		var popup_x_end = popup_x_size + calendar_icon_x_pos + calendar_icon_x_size/2
		if(window_size_x > popup_x_end):
			pos_x = calendar_icon_x_pos + calendar_icon_x_size/2
		else:
			pos_x = window_size_x - popup_x_size
	
	var pos_y = 0
	if(window_size_y > (popup_y_size + calendar_icon_y_size/2)):
		var popup_y_end = popup_y_size + calendar_icon_y_pos + calendar_icon_y_size/2
		if(window_size_y > popup_y_end):
			pos_y = calendar_icon_y_pos + calendar_icon_y_size/2
		else:
			pos_y = window_size_y - popup_y_size
			
	popup.set_global_position(Vector2(pos_x, pos_y))


func grid_button_pressed(button : Button):
	popup.hide()
	set_pressed(false)
	selected_date.day = int(button.get_text())
	refresh_data()
	emit_signal("date_selected", selected_date)


func _on_PreviousYear_pressed():
	selected_date.year -= 1
	refresh_data()


func _on_PreviousMonth_pressed():
	selected_date.decrement_month()
	refresh_data()


func _on_NextMonth_pressed():
	selected_date.increment_month()
	refresh_data()


func _on_NextYear_pressed():
	selected_date.year += 1
	refresh_data()


func refresh_data():
	var month_name : String = Date.get_month_name(selected_date.month)
	self.text = selected_date.date("YYYY-MM-DD")
	title.text = str(month_name, " ", selected_date.year) 
	update_calendar_buttons()


func update_calendar_buttons():
	# Clear buttons
	for child in days_grid.get_children():
		if child is Button:
			child.set_text("")
			child.set_disabled(true)
			child.set_flat(false)
	
	var days_in_month : int = _get_days_in_month(selected_date.month, selected_date.year)
	var start_day_of_week : int = _get_weekday(1, selected_date.month, selected_date.year)
	for i in range(days_in_month):
		var button : Button = days_grid.get_child(7 + i + start_day_of_week)
		button.set_text(str(i + 1))
		button.set_disabled(false)
		
		# If the day entered is "today"
		var datetime := Time.get_date_dict_from_system()
		var is_today = i + 1 == datetime["day"] && selected_date.year == datetime["year"] && selected_date.month == datetime["month"]
		if is_today: button.set_flat(is_today)


const month_values : Array = [0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4]
func _get_weekday(day : int, month : int, year : int, is_sunday_first : bool = false) -> int:
	if(month < 3): year -= 1
	# Calculate the day of the week using Zeller's congruence formula
	var leap_years : int = int(float(year) / 4) - int(float(year) / 100) + int(float(year) / 400)
	var weekday : int = (year + (leap_years + month_values[month - 1] + day)) % 7
	return weekday if is_sunday_first else (weekday + 6) % 7 #Shifted weekday


func _get_days_in_month(month : int, year : int) -> int:
	if(month == Time.MONTH_FEBRUARY):
		return 29 if(_is_leap_year(year)) else 28
	if(month == Time.MONTH_APRIL || month == Time.MONTH_JUNE || month == Time.MONTH_SEPTEMBER || month == Time.MONTH_NOVEMBER):
		return 30
	return 31


func _is_leap_year(year : int) -> bool:
	return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)

func _on_visibility_changed() -> void:
	if not visible:
		popup.hide()
