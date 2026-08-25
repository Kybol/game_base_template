extends Node
class_name OpenExtendedMenuBtn

###################### VARIABLES ######################
# SIGNALS
signal self_sent(btn: OpenExtendedMenuBtn);

# NAMES
@export var btn_name: String;

###################### FUNCTIONS ######################
# BASE
func _ready() -> void:
	self.text = btn_name;
	
	self.pressed.connect(_send_self);

# PUBLIC

# PRIVATE
func _send_self() -> void:
	self_sent.emit(self);
