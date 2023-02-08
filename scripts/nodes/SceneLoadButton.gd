extends Button
class_name SceneLoadButton

export(String, FILE, "*.tscn,*.scn") var screen_path

func _pressed():
	ScreenStack.push_scene(screen_path)
