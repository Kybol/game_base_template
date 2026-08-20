extends Button
class_name  InputMapperButton

###################### VARIABLES ######################
# LABELS
@export var _action_name: String;
@export var _action_label: Label;
@export var _action: String;
@export var _input_name: String: set = set_input_name
@export var _input_label: Label;

# BOOL
var is_remapping: bool = false;

###################### FUNCTIONS ######################
# BASE
func _ready() -> void:
	_action_label.text = _action_name;
	_input_label.text = _input_name;

	self.pressed.connect(_await_new_key);


func set_action_name(new_name: String, new_action: String) -> void:
	_action_name = new_name;
	_action = new_action;


func set_input_name(new_name: String) -> void:
	_input_name = new_name;


# PRIVATE
func _await_new_key() -> void:
	if is_remapping: return;
	
	is_remapping = true;
	_input_label.text = "Press key to bind...";


func _input(event: InputEvent) -> void:
	if !is_remapping: return;
	
	if ( event is InputEventKey || 
		(event is InputEventMouseButton && event.pressed )
	):
		if event is InputEventMouseButton && event.double_click:
			event.double_click = false;
			
		InputMap.action_erase_events(_action);
		InputMap.action_add_event(_action, event);
		_update_action_button(event);
		
		is_remapping = false;
		
		accept_event();


func _update_action_button(event: InputEvent):
	_input_label.text = event.as_text().trim_suffix(" (Physical)");
