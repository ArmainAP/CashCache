extends Control

onready var header_label = $VBoxContainer/Header/HBoxContainer/ResizeableLabel

func _ready():
	header_label.text = Time.get_date_string_from_system()
