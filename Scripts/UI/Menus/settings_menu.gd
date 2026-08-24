extends OverlayedMenu

###################### VARIABLES ######################
# BUTTONS
@export_group("Buttons")
@export_subgroup("Video")
@export var _has_video_settings: bool = true;
@export var _fullscreen_btn: Button;
@export var _resolution_btn: Button;
@export_subgroup("Audio")
@export var _has_music_settings: bool = true;
@export var _mute_music_btn: Button;
@export var _music_slider: Slider;
@export_subgroup("Audio SFX")
@export var _has_sfx_settings: bool = true;
@export var _mute_sfx_btn: Button;
@export var _sfx_slider: Slider;


@export_group("Audio Buses")
@export var _music_audio_bus: String = "Music";
@export var _sfx_audio_bus: String = "SFX";
var _music_audio_bus_index : int;
var _sfx_audio_bus_index : int;

# FLAGS
var _is_audio_mutable: bool = true;

# SAVE DATA
var _is_full_screen: bool = false;
var _screen_resolution: String;
var _is_music_muted: bool = false;
var _is_sfx_muted: bool = false;
var _music_volume: float;
var _sfx_volume: float;
var _saved_music_volume: float;
var _saved_sfx_volume: float;

###################### FUNCTIONS ######################
# BASE
func _ready() -> void:
	super();
	
	if _has_video_settings :
		_init_video_settings();
	else:
		_fullscreen_btn.visible = false;
		_resolution_btn.visible = false;
	
	if _has_music_settings or !_has_sfx_settings:
		_init_audio_settings();
	else:
		_mute_music_btn.visible = false;
		_music_slider.visible = false;
		_mute_sfx_btn.visible = false;
		_sfx_slider.visible = false;


# PRIVATE
func _init_video_settings() -> void:
	var video_saved_settings: Dictionary = ConfigFileHandler.load_video_settings();
	
	_init_resolution_btn(video_saved_settings);
	_init_fullscreen(video_saved_settings);


func _init_resolution_btn(saved_settings: Dictionary) -> void:
	_add_resolutions_to_btn()
	
	var saved_res_key: String = ConfigFileHandler.video_settings[ConfigFileHandler.video.RESOLUTION];
	_resolution_btn.item_selected.connect(_set_resolution);
	_screen_resolution = saved_settings[saved_res_key];
	#_screen_resolution = SaveLoad.saved_data["screenResolution"];
	_init_screen_resolution();


func _add_resolutions_to_btn() -> void:
	for resolution in GUI.resolutions:
		_resolution_btn.add_item(resolution);


func _init_screen_resolution() -> void:
	var resolution_i: int;
	
	if _screen_resolution == "" :
		var window_size: String = str(get_window().size.x, "x", get_window().size.y);
		resolution_i = GUI.resolutions.keys().find(window_size);
	else:
		resolution_i = GUI.resolutions.keys().find(_screen_resolution);
		get_window().set_size(GUI.resolutions[_screen_resolution]);
		GUI.center_window();
		
	_resolution_btn.selected = resolution_i;


func _init_fullscreen(saved_settings: Dictionary) -> void:
	_fullscreen_btn.toggled.connect(_toggle_fullscreen);
	
	var saved_fulls_key: String = ConfigFileHandler.video_settings[ConfigFileHandler.video.FULLSCREEN];
	_is_full_screen = saved_settings[saved_fulls_key];
	
	_fullscreen_btn.button_pressed = _is_full_screen;




func _init_audio_settings() -> void:
	var audio_saved_settings: Dictionary = ConfigFileHandler.load_audio_settings();
	
	if _has_music_settings:
		_init_music(audio_saved_settings);

	if _has_sfx_settings:
		_init_sfx(audio_saved_settings);


func _init_music(saved_settings: Dictionary) -> void:
	if _mute_music_btn == null || _music_slider == null: return;
	
	_mute_music_btn.toggled.connect(_mute_music);
	_music_slider.value_changed.connect(_change_music_volume);
	_music_audio_bus_index = AudioServer.get_bus_index(_music_audio_bus);
	
	var saved_muted_key: String = ConfigFileHandler.audio_settings[ConfigFileHandler.audio.MUSIC_MUTED];
	var saved_volume_key: String = ConfigFileHandler.audio_settings[ConfigFileHandler.audio.MUSIC_VOLUME];
	_is_music_muted = saved_settings[saved_muted_key];
	_music_volume = saved_settings[saved_volume_key];
	
	_mute_music_btn.button_pressed = _is_music_muted;
	_music_slider.value = _music_volume;


func _init_sfx(saved_settings: Dictionary) -> void:
	if _mute_sfx_btn == null || _sfx_slider == null: return;
	
	_mute_sfx_btn.toggled.connect(_mute_sfx);
	_sfx_slider.value_changed.connect(_change_sfx_volume);
	_sfx_audio_bus_index = AudioServer.get_bus_index(_sfx_audio_bus);
	
	var saved_muted_key: String = ConfigFileHandler.audio_settings[ConfigFileHandler.audio.SFX_MUTED];
	var saved_volume_key: String = ConfigFileHandler.audio_settings[ConfigFileHandler.audio.SFX_VOLUME];
	_is_sfx_muted = saved_settings[saved_muted_key];
	_sfx_volume = saved_settings[saved_volume_key];
	
	_mute_sfx_btn.button_pressed = _is_sfx_muted;
	_sfx_slider.value = _sfx_volume;


func _toggle_fullscreen(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
		_is_full_screen = true;
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
		_is_full_screen = false;
	
	ConfigFileHandler.save_video_settings(ConfigFileHandler.video.FULLSCREEN, _is_full_screen);


func _set_resolution(i: int) -> void:
	var resolution: String = _resolution_btn.get_item_text(i);
	get_window().set_size(GUI.resolutions[resolution]);
	GUI.center_window();
	
	ConfigFileHandler.save_video_settings(ConfigFileHandler.video.RESOLUTION, resolution);



func _mute_music(is_muted: bool):
	if _is_audio_mutable == false: return;
	
	if is_muted == true:
		_saved_music_volume = _music_volume if _music_volume != 0 else _music_slider.max_value;
	
	_mute(
		_music_slider, 
		_saved_music_volume, 
		is_muted, 
		ConfigFileHandler.audio.MUSIC_MUTED
		);
		
	_is_music_muted = is_muted;


func _mute_sfx(is_muted: bool):
	if _is_audio_mutable == false: return;
	
	if is_muted == true:
		_saved_sfx_volume = _sfx_volume if _sfx_volume != 0 else _sfx_slider.max_value;
	
	_mute(
		_sfx_slider, 
		_saved_sfx_volume, 
		is_muted, 
		ConfigFileHandler.audio.SFX_MUTED
		);
	
	_is_sfx_muted = is_muted;


func _change_music_volume(value: float):
	_change_volume(
		_music_audio_bus_index, 
		_is_music_muted, 
		ConfigFileHandler.audio.MUSIC_MUTED,
		_mute_music_btn, 
		value,
		ConfigFileHandler.audio.MUSIC_VOLUME
		);
		
	_music_volume = value;
	_is_music_muted = _mute_music_btn.button_pressed;


func _change_sfx_volume(value: float):
	_change_volume(
		_sfx_audio_bus_index,  
		_is_sfx_muted, 
		ConfigFileHandler.audio.SFX_MUTED,
		_mute_sfx_btn, 
		value,
		ConfigFileHandler.audio.SFX_VOLUME
		);
	
	_sfx_volume = value;
	_is_sfx_muted = _mute_sfx_btn.button_pressed;


func _mute(slider: Slider, volume: float, is_muted: bool, save_index: int) -> void:
	if is_muted == true:
		slider.value = slider.min_value;
	else:
		slider.value = volume;
	
	ConfigFileHandler.save_audio_settings(save_index, is_muted);


func _change_volume(audio_bus_index: int, is_muted: bool, save_mute_index: int,
					mute_btn: Button, value: float, save_index: int) -> void:
	var new_decibels: float = linear_to_db(value);
	AudioServer.set_bus_volume_db(audio_bus_index, new_decibels);
	
	if is_muted == false && value == 0.0:
		mute_btn.button_pressed = true;
		return;

	if is_muted == true && value > 0.0:
		_is_audio_mutable = false;
		mute_btn.button_pressed = false;
		ConfigFileHandler.save_audio_settings(save_mute_index , false);
		_is_audio_mutable = true;
	
	ConfigFileHandler.save_audio_settings(save_index , value);
