extends LineEdit
class_name NumericLineEdit

var value : float = 0.0 # export as needed

func _ready() -> void:
  connect("text_changed", self, "_on_LineEdit_text_changed")

func _on_LineEdit_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		value = float(new_text)
	else: # optional rollback to last good one
		self.text = str(value)
