extends Control
class_name Main


const btn_add_symbol = preload("res://src/controls/button_add_symbol.tscn")
const symbol_visual = preload("res://src/visual_symbols/assignment_visual.tscn")

#region Symbols

@abstract class Symbol:
	pass

class StartSymbol extends Symbol:
	pass

class EndSymbol extends Symbol:
	pass

class AssignmentSymbol extends Symbol:
	var variable := Variable.new()
	var values: Array[Value]

class ReassignmentSymbol extends Symbol:
	var variable: Variable
	var values: Array[Value]
	func _init(variable_ref: Variable) -> void:
		variable = variable_ref

class OutputSymbol extends Symbol:
	var values: Array[Value]

class InputSymbol extends Symbol:
	var variable := Variable.new()
	var prompt: Array[Value]

class SelectionSymbol extends Symbol:
	# TODO: Implement conditions
	var condition: Variant
	var yes_branch: Array[Symbol] = []
	var no_branch: Array[Symbol] = []

class LoopSymbol extends Symbol:
	var condition: Variant
	var inside: Array[Symbol]


#endregion		
#region Values

@abstract class Value:
	@abstract func get_value() -> Variant

class StringValue extends Value:
	var value: String
	func get_value() -> String:
		return value

class NumberValue extends Value:
	var value: float
	func get_value() -> float:
		return value

class VariableValue extends Value:
	var value: Variable
	func get_value() -> Variable:
		return value

#endregion

class Variable:
	enum Type {
		STRING,
		NUMBER
	}
	signal name_changed(new_value: String)
	var name: String:
		set(value):
			name = value
			name = name.strip_edges()

			# Enforce alphanumeric input, no spaces allowed either
			var regex := RegEx.create_from_string("[^A-Za-z0-9_]")
			var result := regex.search(name)
			if result:
				name = name.remove_chars(result.get_string())
			
			# No numbers allowed at start
			regex = RegEx.create_from_string("^([0-9]+)(.*)")
			result = regex.search(name)
			if result:
				name = result.get_string(2)

			name_changed.emit(name)
	var type: Type


var main_chart: Array[Symbol] = [
	StartSymbol.new(),
	EndSymbol.new()
]

# NOTE: We will need to properly CRUD this list
# As in, when new assignment symbol is added, add a new variable here
# When the symbol is deleted, delete the variable from here too
# Oh god you'll need a way to error on stale references...
static var variable_list: Array[Variable] = []

@onready var flowchart: VBoxContainer = %Flowchart
@onready var properties_panel: TabContainer = %PropertiesPanel
@onready var properties_sidebar: HBoxContainer = %PropertiesSidebar
@onready var assignment_panel: AssignmentPanel = %AssignmentPanel


func _ready() -> void:
	update_visuals()
	properties_sidebar.hide()


func update_visuals() -> void:
	for child: Node in flowchart.get_children():
		child.queue_free()
	
	for i in main_chart.size():
		var symbol: Symbol = main_chart[i]
		var symbol_rep: VisualSymbol = symbol_visual.instantiate()
		symbol_rep.bound_symbol = symbol
		if symbol is StartSymbol:
			symbol_rep.text = "Start"
			symbol_rep.disabled = true
		elif symbol is EndSymbol:
			symbol_rep.text = "End"
			symbol_rep.disabled = true
		elif symbol is AssignmentSymbol:
			var assignment_symbol := symbol as AssignmentSymbol
			symbol_rep.text = str("SET ", assignment_symbol.variable.name)
			assignment_symbol.variable.name_changed.connect((symbol_rep as AssignmentVisual)._on_variable_name_changed)
		symbol_rep.pressed.connect(_on_symbol_pressed.bind(symbol))
		flowchart.add_child(symbol_rep)

		if symbol != main_chart.back():
			var btn_add: Button = btn_add_symbol.instantiate()
			btn_add.pressed.connect(_on_add_symbol.bind(i))
			flowchart.add_child(btn_add)


func _on_symbol_pressed(symbol: Symbol) -> void:
	properties_sidebar.show()
	var current_panel: PropertyPanel
	if symbol is AssignmentSymbol:
		current_panel = assignment_panel
	
	properties_panel.current_tab = current_panel.get_index()
	current_panel.bind_symbol(symbol)


# @action
# TODO: How do we know where to add the new symbol?
# Stopgap for now...we'll just use the index (won't work once we have branches)
func _on_add_symbol(idx: int) -> void:
	var new_symbol := AssignmentSymbol.new()
	main_chart.insert(idx + 1, new_symbol)
	variable_list.append(new_symbol.variable)
	update_visuals()


# @action
# TODO
func _on_remove_symbol(_symbol: Symbol) -> void:
	# TODO: When removing AssignmentSymbol, also remove its variable from the list
	pass


func _on_hide_button_pressed() -> void:
	properties_sidebar.hide()
