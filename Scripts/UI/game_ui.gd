extends Control

###################### VARIABLES ######################
# MENUS
@export var _pause_menu: OverlayedMenu;

#BOOLEAN
@export var _is_pausabled: bool = true

###################### FUNCTIONS ######################
# BASE
func _ready() -> void:
	_pause_menu.disable();
	
	if _is_pausabled == false: return
	_pause_menu.closed.connect(_on_finished_paused);


# PRIVATE
func _input(event: InputEvent) -> void:
	if _pause_menu.is_active == true or _is_pausabled == false : return
	
	if event.is_action_pressed("return"):
		_pause_menu.enable();
		_is_pausabled = false;


func _on_finished_paused() -> void:
	_is_pausabled = false;
	await Utils.set_timer(0.1);
	
	_is_pausabled = true;
