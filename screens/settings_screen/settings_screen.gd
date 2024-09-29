extends Control

func _on_ScenePopButtons_pressed():
	var options = SceneManager.create_options(0)
	SceneManager.change_scene_to_file("back", options, options, SceneManager.create_general_options())
