extends Node
###################### VARIABLES ######################
# SAVE
var _save_path: String = "user://game.json";

var saved_data: Dictionary = {
	"isFullscreen" : false,
	"screenResolution" : "",
	"musicVolume" : 1,
	"isMusicMuted" : false,
	"sfxVolume" : 1,
	"isSfxMuted" : false
}

var is_loaded: bool;

###################### FUNCTIONS ######################
func save_data() -> void:
	var file: FileAccess = FileAccess.open(_save_path, FileAccess.WRITE);
	file.store_var(saved_data);
	file.close();


func load_save() -> void:
	is_loaded = false;
	
	if FileAccess.file_exists(_save_path):
		var file: FileAccess = FileAccess.open(_save_path, FileAccess.READ);
		var data: Dictionary = file.get_var();
		for key in data:
			if !saved_data.has(key): continue;
			saved_data[key] = data[key];
		file.close();
		is_loaded = true;
	else:
		print("no save file found");


func load(key: String) -> void:
	is_loaded = false;
	
	if FileAccess.file_exists(_save_path):
		var file: FileAccess = FileAccess.open(_save_path, FileAccess.READ);
		var data: Dictionary = file.get_var();
		if !saved_data.has(key): return;
		saved_data[key] = data[key];
		file.close();
		is_loaded = true;
	else:
		print("no save file found");


func save_screen_resolution(resolution: String) -> void:
	saved_data["screenResolution"] = resolution;
	save_data();


func save_fullscreen(is_fullscreen: bool) -> void:
	saved_data["isFullscreen"] = is_fullscreen;
	save_data();


func save_music_muted(is_muted:bool) -> void:
	saved_data["isMusicMuted"] = is_muted;
	save_data();


func save_music_volume(volume: float) -> void:
	saved_data["musicVolume"] = volume;
	save_data();


func save_sfx_muted(is_muted:bool) -> void:
	saved_data["isSfxMuted"] = is_muted;
	save_data();


func save_sfx_volume(volume: float) -> void:
	saved_data["sfxVolume"] = volume;
	save_data();
