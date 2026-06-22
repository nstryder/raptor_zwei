extends VBoxContainer
class_name VariableBox

@onready var variable_select: OptionButton = %VariableSelect


func bind_variable_value(variable_value: Main.VariableValue) -> void:
	for i: int in Main.variable_list.size():
		var variable: Main.Variable = Main.variable_list[i]
		variable_select.add_item(variable.name)
		if variable_value.get_value() == variable:
			variable_select.select(i)
		variable.name_changed.connect(_on_variable_name_changed.bind(i))
	variable_select.item_selected.connect(_on_variable_select_item_selected.bind(variable_value))


func _on_variable_name_changed(new_name: String, idx: int) -> void:
	variable_select.set_item_text(idx, new_name)


func _on_variable_select_item_selected(idx: int, variable_value: Main.VariableValue) -> void:
	var selected_variable: Main.Variable = Main.variable_list[idx]
	variable_value.value = selected_variable