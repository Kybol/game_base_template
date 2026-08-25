extends OverlayedMenu

###################### VARIABLES ######################
# MENUS & BUTTONS
@export var first_button: OpenExtendedMenuBtn;
@export var open_menu_buttons: Dictionary[OpenExtendedMenuBtn,OverlayedMenu];

var open_menu_flags: Dictionary[OpenExtendedMenuBtn, bool];
var current_open_menu: OverlayedMenu;


###################### FUNCTIONS ######################
# BASE
func _ready() -> void:
	super();
	
	_init_open_flags_for_menus(false);
	
	_open_menu(first_button);
	
	for btn in open_menu_buttons:
		btn.self_sent.connect(_open_menu);


# PUBLIC

# PRIVATE
func _init_open_flags_for_menus(value: bool) -> void:
	for btn in open_menu_buttons:
		open_menu_flags.set(btn, value);
		_close_menu(open_menu_buttons[btn]);
		


func _open_menu(pressed_button: OpenExtendedMenuBtn) -> void:
	if open_menu_flags[pressed_button]: return;
	var menu_to_open: OverlayedMenu = open_menu_buttons.get(pressed_button);
	menu_to_open.enable();
	
	if current_open_menu:
		_close_menu(current_open_menu);
	_set_open_flags_for_one_menu(pressed_button, true);
	
	current_open_menu = menu_to_open;


func _close_menu(menu_to_close: OverlayedMenu) -> void:
	if current_open_menu && menu_to_close != current_open_menu: return;
	
	menu_to_close.can_be_closed = true;
	menu_to_close.disable();
	menu_to_close.can_be_closed = false;


func _set_open_flags_for_one_menu(menu_key: OpenExtendedMenuBtn,value: bool) -> void:
	for btn in open_menu_flags:
		if btn == menu_key:
			open_menu_flags[btn] = value;
			continue;
		open_menu_flags[btn] = !value;
