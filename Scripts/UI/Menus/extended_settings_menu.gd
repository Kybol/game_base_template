extends OverlayedMenu

###################### VARIABLES ######################
# MENUS
@export var settings_menu: OverlayedMenu;
@export var controls_menu: OverlayedMenu;

# BUTTONS
@export var open_settings_button: Button;
@export var open_controls_button: Button;

# FLAGS
enum menus_name {SETTINGS, CONTROLS};

var is_open:Array [bool] = [];


###################### FUNCTIONS ######################
# BASE
func _ready() -> void:
	super();
	
	_init_open_flags_for_menus(false);
	
	_open_settings();
	open_settings_button.pressed.connect(_open_settings);
	open_controls_button.pressed.connect(_open_controls);
	


# PUBLIC

# PRIVATE
func _init_open_flags_for_menus(value: bool) -> void:
	for enum_name in menus_name:
		is_open.append(value);


func _open_settings() -> void:
	settings_menu.enable();
	
	controls_menu.can_be_closed = true;
	controls_menu.disable();
	controls_menu.can_be_closed = false;
	_set_open_flags_for_one_menu(menus_name.SETTINGS, true);


func _open_controls() -> void:
	controls_menu.enable();
	
	settings_menu.can_be_closed = true;
	settings_menu.disable();
	settings_menu.can_be_closed = true;
	_set_open_flags_for_one_menu(menus_name.CONTROLS, true);


func _set_open_flags_for_one_menu(displayed_menu: int,value: bool) -> void:
	for enum_name in menus_name:
		var enum_value: int = menus_name[enum_name];
		if enum_value == displayed_menu:
			is_open[enum_value] = value;
			continue;
		
		is_open[enum_value] = !value;
