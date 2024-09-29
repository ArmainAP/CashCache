# Code modified from https://github.com/Pukkah/HTML5-File-Exchange-for-Godot

extends Node

signal read_completed

var js_callback = JavaScriptBridge.create_callback(load_handler);
var js_interface;

func _ready():
	if is_web():
		_define_js()
		js_interface = JavaScriptBridge.get_interface("_HTML5FileExchange");

func _define_js()->void:
	#Define JS script
	JavaScriptBridge.eval("""
	var _HTML5FileExchange = {};
	_HTML5FileExchange.upload = function(gd_callback) {
		canceled = true;
		var input = document.createElement('INPUT'); 
		input.setAttribute("type", "file");
		input.setAttribute("accept", ".ccf");
		input.click();
		input.addEventListener('change', event => {
			if (event.target.files.length > 0){
				canceled = false;}
			var file = event.target.files[0];
			var reader = new FileReader();
			this.fileType = file.type;
			reader.readAsArrayBuffer(file);
			reader.onloadend = (evt) => { // Since here's it's arrow function, "this" still refers to _HTML5FileExchange
				if (evt.target.readyState == FileReader.DONE) {
					this.result = evt.target.result;
					this.fileName = file.name;
					gd_callback(); // It's hard to retrieve value from callback argument, so it's just for notification
				}
			}
		  });
	}
	""", true)


func load_handler(_args):
	emit_signal("read_completed")


func upload_file() -> String:
	if !is_web():
		return ""
	
	js_interface.upload(js_callback);
	
	await self.read_completed
	
	var file_name = JavaScriptBridge.eval("_HTML5FileExchange.fileName", true)
	var file_data = JavaScriptBridge.eval("_HTML5FileExchange.result", true) # interface doesn't work as expected for some reason
	
	var file_path : String = UserSettings.get_default_folder().path_join(file_name)
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_buffer(file_data)
	file.close()
	
	return file_path


func is_web() -> bool:
	return OS.get_name() == "HTML5" and OS.has_feature('JavaScript')


func download(file_path : String) -> void:
	if !is_web(): return
	var file = FileAccess.open(file_path, FileAccess.READ)
	JavaScriptBridge.download_buffer(file.get_buffer(file.get_length()), file_path.get_file())
