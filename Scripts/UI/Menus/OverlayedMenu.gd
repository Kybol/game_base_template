extends Menu
class_name OverlayedMenu
###################### VARIABLES ######################
# SIGNALS
signal closed;

# LABELS
@export var _title: String;
@export var _title_label: Label;

# BUTTONS
@export var _exit_btn: Button;

# FLAGS
@export var can_be_closed: bool = true;

#BOOLEANS
var is_active: bool;

###################### FUNCTIONS ######################
# BASE
func _ready() -> void:
	super();
	
	_title_label.text = _title;
	
	if can_be_closed:
		_exit_btn.pressed.connect(disable);
	_exit_btn.visible = can_be_closed;


#PUBLIC 
func disable() -> void:
	if !can_be_closed: return
	
	self.hide();
	self.mouse_filter = MOUSE_FILTER_IGNORE;
	is_active = false;
	
	closed.emit();


func enable() -> void:
	self.show();
	self.mouse_filter = MOUSE_FILTER_STOP;
	is_active = true;


#PRIVATE
func _input(event):
	if !is_active or !can_be_closed: return;
	
	if event.is_action_pressed("return"):
		disable();
