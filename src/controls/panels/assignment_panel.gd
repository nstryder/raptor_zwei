extends PropertyPanel
class_name AssignmentPanel

const string_box_scene: PackedScene = preload("res://src/controls/value_boxes/string_box.tscn")
const variable_box_scene: PackedScene = preload("res://src/controls/value_boxes/variable_box.tscn")

@onready var _variable_name: LineEdit = $VariableName
@onready var _value_box: VBoxContainer = %ValueBox

# TODO: Handle NumberValues
func bind_symbol(selected_symbol: Main.Symbol) -> void:
	symbol = selected_symbol
	# Gotta use temp variable to properly cast downwards
	var assignment_symbol := selected_symbol as Main.AssignmentSymbol
	_variable_name.text = assignment_symbol.variable.name
	for node in _value_box.get_children():
		node.queue_free()
	for value: Main.Value in assignment_symbol.variable.values:
		if value is Main.StringValue:
			create_string_box(value as Main.StringValue)
		elif value is Main.VariableValue:
			create_variable_box(value as Main.VariableValue)


func create_string_box(string_value: Main.StringValue) -> void:
	var string_box: StringBox = string_box_scene.instantiate()
	_value_box.add_child(string_box)
	string_box.bind_string_value(string_value)


func create_variable_box(variable_value: Main.VariableValue) -> void:
	var variable_box: VariableBox = variable_box_scene.instantiate()
	_value_box.add_child(variable_box)
	variable_box.bind_variable_value(variable_value)

	
func _on_button_string_pressed() -> void:
	var assignment_symbol := symbol as Main.AssignmentSymbol
	var new_string_value := Main.StringValue.new()
	assignment_symbol.variable.values.append(new_string_value)
	create_string_box(new_string_value)


# TODO
func _on_button_number_pressed() -> void:
	pass # Replace with function body.


func _on_button_variable_pressed() -> void:
	var assignment_symbol := symbol as Main.AssignmentSymbol
	var new_variable_value := Main.VariableValue.new()
	assignment_symbol.variable.values.append(new_variable_value)
	create_variable_box(new_variable_value)
	

# TODO: Validate variable names
# TODO: Tie changes to variable name
func _on_variable_name_text_changed(_new_text: String) -> void:
	var assignment_symbol := symbol as Main.AssignmentSymbol
	assignment_symbol.variable.name = _new_text