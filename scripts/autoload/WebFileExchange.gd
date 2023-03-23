# Code modified from https://github.com/Pukkah/HTML5-File-Exchange-for-Godot

extends Node

signal read_completed

var js_callback = JavaScript.create_callback(self, "load_handler");
var js_interface;

func _ready():
	if is_web():
		_define_js()
		js_interface = JavaScript.get_interface("_HTML5FileExchange");

func _define_js()->void:
	#Define JS script
	JavaScript.eval("""
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
		return
	
	js_interface.upload(js_callback);
	
	yield(self, "read_completed")
	
	var file_name = JavaScript.eval("_HTML5FileExchange.fileName", true)
	var file_data = JavaScript.eval("_HTML5FileExchange.result", true) # interface doesn't work as expected for some reason
		
	var file_path : String = UserSettings.get_default_folder().plus_file(file_name)
	var file = File.new()
	file.open(file_path, File.WRITE)
	file.store_buffer(file_data)
	file.close()
	
	print(file_path)
	
	return file_path


func is_web() -> bool:
	return OS.get_name() == "HTML5" and OS.has_feature('JavaScript')


#func save_image(image:Image, fileName:String = "export.png")->void:
#	if !is_web():
#		return
	
#	image.clear_mipmaps()
#	var buffer = image.save_png_to_buffer()
#	JavaScript.download_buffer(buffer, fileName)
