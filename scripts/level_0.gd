extends Node3D

var window_size = Vector2i(1280, 720)
var window: Window

func _ready():
	window = get_window()
	window.current_screen = 0
	window.title = ":3"

func _process(_delta):
	var size = DisplayServer.window_get_size()
	if window.size != window_size:
		var window_w = window.size.x
		var window_h = window_w / 16.0 * 9
		window.size = Vector2i(window_w, window_h)
		window_size = window.size
	


