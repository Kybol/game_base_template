extends OverlayedMenu

###################### VARIABLES ######################
# BUTTONS
@export_subgroup("Buttons")
@export var _resume_btn: Button;
@export var _settings_btn: Button;
@export var _main_menu_btn: Button;

# SETTINGS
@export_subgroup("Settings Menu")
@export var _settings_menu: OverlayedMenu;

# SCENES
@export_subgroup("Main Menu")
@export var _main_menu_path: PackedScene;

# PAUSE
@onready var _pause_menu: Panel = $Panel;

###################### FUNCTIONS ######################
# BASE
func _ready() -> void:
	super();
	
	_resume_btn.pressed.connect(_resume_game);
	_main_menu_btn.pressed.connect(_return_to_main_menu);
	
	_settings_menu.disable();
	_settings_btn.pressed.connect(_open_settings);
	_settings_menu.closed.connect(_on_settings_closed);

# PUBLIC
func disable() -> void:
	_pause_menu.hide();
	_pause_menu.mouse_filter = MOUSE_FILTER_IGNORE;
	is_active = false;
	
	closed.emit();


func enable() -> void:
	_pause_menu.show();
	_pause_menu.mouse_filter = MOUSE_FILTER_STOP;
	is_active = true;


# PRIVATE
func _resume_game() -> void:
	disable();


func _return_to_main_menu() -> void:
	get_tree().change_scene_to_packed(_main_menu_path);


func _open_settings() -> void:
	_settings_menu.enable();
	disable();


func _on_settings_closed() -> void:
	enable();
