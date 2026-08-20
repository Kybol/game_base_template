extends CanvasLayer

###################### CONSTANTS ######################

# FOR SETTINGS
var resolutions: Dictionary [String, Vector2i] = {
	"3840x2160" = Vector2i(3840, 2160),
	"2560x1440" = Vector2i(2560, 1440),
	"1920x1080" = Vector2i(1920, 1080),
	"1366x768" = Vector2i(1366, 768),
	"1280x720" = Vector2i(1280, 720),
	"1440x900" = Vector2i(1440, 900),
	"1152x648" = Vector2i(1152,648),
	"1600x900" = Vector2i(1600, 900),
	"1024x600" = Vector2i(1024, 600),
	"800x600" = Vector2i(800, 600),
}


###################### FUNCTIONS ######################

func center_window() -> void:
	var screen_half: Vector2i = DisplayServer.screen_get_size() / 2;
	var screen_pos: Vector2i = DisplayServer.screen_get_position();
	var screen_center: Vector2i =  screen_pos + screen_half;
	
	var window: Window = get_window();
	var window_size: Vector2i = window.get_size_with_decorations();
	
	window.set_position(screen_center - window_size /2);
