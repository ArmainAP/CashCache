extends Control

func _on_ScenePopButtons_pressed():
	var options = SceneManager.create_options(0)
	SceneManager.change_scene("back", options, options, SceneManager.create_general_options())
