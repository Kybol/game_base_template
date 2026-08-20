extends Node

###################### VARIABLES ######################
# CONSTANT
const SETTINGS_FILE_PATH = "user://settings.ini";
var config: ConfigFile = ConfigFile.new();

const KEYS_SECTION_TITLE: String = "keybinding";
const VIDEO_SECTION_TITLE: String = "video";
const AUDIO_SECTION_TITLE: String = "audio";

# STRUCTURES
enum keys { RETURN };
enum video { FULLSCREEN, RESOLUTION };
enum audio { MUSIC_MUTED, MUSIC_VOLUME, SFX_MUTED, SFX_VOLUME };

var keys_map: Array [String] = [
	"return",
];
var video_settings: Array [String] = [ "fullscreen", "resolution" ];
var audio_settings: Array [String] = [ 
	"isMusicMuted", "musicVolume",
	"isSfxcMuted", "sfxVolume",
	];

###################### FUNCTIONS ######################
# BASE
func _ready() -> void:
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		_create_config_file();
		return;
	
	config.load(SETTINGS_FILE_PATH);

# PUBLIC
func save_video_settings(setting_index: int, value) -> void:
	_save_settings(VIDEO_SECTION_TITLE, video_settings, setting_index, value);


func load_video_settings() -> Dictionary:
	return _load_settings(VIDEO_SECTION_TITLE);


func save_audio_settings(setting_index: int, value) -> void:
	_save_settings(AUDIO_SECTION_TITLE, audio_settings, setting_index, value);


func load_audio_settings() -> Dictionary:
	return _load_settings(AUDIO_SECTION_TITLE);


func save_keys_settings(action: String, event: InputEvent) -> void:
	var event_string: String;
	
	if event is InputEventKey:
		event_string = OS.get_keycode_string(event.physical_keycode);
	elif event is InputEventMouse:
		event_string = "mouse_" + str(event.button_index);
	
	config.set_value(KEYS_SECTION_TITLE, action, event_string);
	config.save(SETTINGS_FILE_PATH);


func load_keys_settings() -> Dictionary:
	return _load_settings(KEYS_SECTION_TITLE);


# PRIVATE
func _create_config_file() -> void:
	config.set_value(KEYS_SECTION_TITLE, keys_map[keys.RETURN], "Escape");
		
	config.set_value(VIDEO_SECTION_TITLE, video_settings[video.FULLSCREEN], false);
	config.set_value(VIDEO_SECTION_TITLE, video_settings[video.RESOLUTION], "");
	
	config.set_value(AUDIO_SECTION_TITLE, audio_settings[audio.MUSIC_MUTED], false);
	config.set_value(AUDIO_SECTION_TITLE, audio_settings[audio.MUSIC_VOLUME], 1.0);
	config.set_value(AUDIO_SECTION_TITLE, audio_settings[audio.SFX_MUTED], false);
	config.set_value(AUDIO_SECTION_TITLE, audio_settings[audio.SFX_VOLUME],  1.0);
	
	config.save(SETTINGS_FILE_PATH);


func _save_settings(setting_section_name: String, settings_key_array: Array[String], setting_index: int, value) -> void:
	if setting_index >= settings_key_array.size(): return;
	
	var key: String = settings_key_array[setting_index]
	config.set_value(setting_section_name, key, value);
	config.save(SETTINGS_FILE_PATH);


func _load_settings(setting_section_name: String) -> Dictionary:
	var loaded_settings: Dictionary = {};
	
	for key in config.get_section_keys(setting_section_name):
		loaded_settings[key] = config.get_value(setting_section_name, key);
	return loaded_settings;
