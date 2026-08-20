extends Control
class_name Menu

###################### VARIABLES ######################
#CONTAINERS
@export var _buttons_container: Container;

# BUTTONS
@export_subgroup("Buttons (optional)")
@export var _play_btn: Button;
@export var _quit_btn: Button;

###################### FUNCTIONS ######################
# BASE
func _ready() -> void:
	if _play_btn != null:
		_play_btn.pressed.connect(_play);
		
	if _quit_btn != null:
		_quit_btn.pressed.connect(_quit);

func hide_buttons() -> void:
	_buttons_container.hide()

func show_buttons() -> void:
	_buttons_container.show()

# PRIVATE
func _play():
	get_tree().change_scene_to_file('res://Scenes/Game/game.tscn');

func _quit():
	get_tree().quit(0);
