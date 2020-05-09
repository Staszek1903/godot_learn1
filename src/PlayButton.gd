tool
extends Button

export(String,FILE) var scene_dir: String

func _on_PlayButton_button_up() -> void:
	get_tree().change_scene(scene_dir)

func _get_configuration_warning() -> String:
	if(scene_dir == null or scene_dir == ""):
		return "droga do nikąd :("
	else:
		return ""
