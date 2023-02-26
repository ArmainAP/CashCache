extends Node

var current_account : AccountData

func load_account(var file_path : String, var password : String) -> bool:
	var new_file = File.new()
	new_file.open_encrypted_with_pass(file_path, File.READ, password)
	var json_result = JSON.parse(new_file.get_as_text()).result
	new_file.close()
	if json_result is Dictionary:
		current_account = AccountData.new().from_dictionary(json_result as Dictionary)
		return true
	return false
