extends VisualSymbol
class_name AssignmentVisual


func _on_variable_name_changed(new_name: String) -> void:
	text = str("SET ", new_name)