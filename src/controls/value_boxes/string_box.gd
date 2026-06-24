extends VBoxContainer
class_name StringBox

@onready var string_input: TextEdit = %StringValue


func bind_string_value(string_value: Main.StringValue) -> void:
	string_input.text = string_value.get_value()
	string_input.text_changed.connect(_on_string_input_text_changed.bind(string_value))


func _on_string_input_text_changed(string_value: Main.StringValue) -> void:
	string_value.value = string_input.text