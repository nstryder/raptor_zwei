extends HBoxContainer
class_name OperatorSelector

signal operator_selected(operation: Main.Operator)

func _ready() -> void:
	for child: Button in get_children():
		var operator: Main.Operator = Main.Operator[child.name.to_upper()]
		child.pressed.connect(func() -> void:
			operator_selected.emit(operator)
		)
