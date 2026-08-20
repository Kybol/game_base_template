extends Menu

###################### VARIABLES ######################
#BUTTONS
@export var _settings_btn: Button;

# NODES 
@export var _settings_menu: Control;

###################### FUNCTIONS ######################
func _ready() -> void:
	super()
	
	_settings_btn.pressed.connect(_enbale_settings);
	_settings_menu.closed.connect(show_buttons);
	_settings_menu.disable()

func _enbale_settings():
	_settings_menu.enable()
	hide_buttons()
