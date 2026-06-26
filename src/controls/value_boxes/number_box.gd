extends VBoxContainer
class_name NumberBox

@onready var number_input: SpinBox = %NumberInput
@onready var operator_selector: OperatorSelector = %OperatorSelector


func bind_number_value(number_value: Main.NumberValue) -> void:
	number_input.value = number_value.get_value()
	number_input.value_changed.connect(_on_number_input_value_changed.bind(number_value))
	operator_selector.operator_selected.connect(_on_operator_selector_selected.bind(number_value))


func _on_number_input_value_changed(new_value: float, number_value: Main.NumberValue) -> void:
	number_value.value = new_value


func _on_operator_selector_selected(new_operator: Main.Operator, number_value: Main.NumberValue) -> void:
	number_value.operator = new_operator