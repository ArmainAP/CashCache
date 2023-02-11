extends Node

const ACCOUNT_WIZARD_SCREEN := "res://screens/account_wizard_screen/account_wizard_screen.tscn"
const ACCOUNT_SCREEN := "res://screens/account_screen/account_screen.tscn"

var scene_stack : PoolStringArray

func _ready():
	scene_stack.append(ProjectSettings.get("application/run/main_scene"))

func push_scene(var new_scene_path : String) -> void:
	var error := get_tree().change_scene(new_scene_path)
	if error == OK:
		scene_stack.append(new_scene_path)

func pop_scene() -> void:
	var stack_size = scene_stack.size()
	var error := get_tree().change_scene(scene_stack[stack_size-2])
	if error == OK:
		scene_stack.remove(stack_size-1)
