extends Menu
class_name OverlayedMenu
###################### VARIABLES ######################
#SIGNALS
signal closed;

#LABELS
@export var _title: String;
@export var _title_label: Label;

#BUTTONS
@export var _exit_btn: Button;

#BOOLEANS
var is_active: bool;

###################### FUNCTIONS ######################
# BASE
func _ready() -> void:
	super();
	_exit_btn.pressed.connect(disable);
	_title_label.text = _title;


#PUBLIC 
func disable() -> void:
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
	if is_active == false: return
	
	if event.is_action_pressed("return"):
		disable();
