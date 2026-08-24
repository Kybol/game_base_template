extends OverlayedMenu

###################### VARIABLES ######################
# LIST
@export var _action_list: Container;

# BUTTONS
@export var _reset_button: Button;

# PRELOAD
@onready var _input_mapper_button_scene: PackedScene = preload("res://Scenes/UI/Menus/SideMenus/InputMapMenu/input_map_button.tscn");

# DICTIONNARY
# list of the actions from the Input Map in the project settings
# the key needs to match the action name
var input_actions = {
	"return": "Return"
}

###################### FUNCTIONS ######################
# BASE
func _ready() -> void:
	super();
	
	_create_action_list();
	_reset_button.pressed.connect(_reset);
	
# PUBLIC

# PRIVATE
func _create_action_list() -> void:
	InputMap.load_from_project_settings();
	
	for action in _action_list.get_children():
		action.queue_free();
	
	for action in input_actions:
		var button: InputMapperButton = _input_mapper_button_scene.instantiate();
		
		button.set_action_name(input_actions[action], action);
		
		var events: Array [InputEvent] = InputMap.action_get_events(action);
		if events.size() > 0:
			button.set_input_name(events[0].as_text().trim_suffix(" (Physical)"));
		else:
			button.set_input_name("input missing");
		
		_action_list.add_child(button);


func _reset() -> void:
	_create_action_list();
