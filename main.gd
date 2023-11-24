extends Node

@export var websocket_url = "ws://127.0.0.1:3000"

var _client = WebSocketPeer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	_client.connect_to_url(websocket_url)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#$Stage.module = float(1.0 - abs($CharacterBody3D/pivot.rotation.x)/90)
	
	if Input.is_action_just_pressed("Open_Menu"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("FullScreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MAXIMIZED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	
	_client.poll()
	
	var state = _client.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		while _client.get_available_packet_count():
			var data = _client.get_packet().get_string_from_utf8()
			print("Packet: ", JSON.parse_string(data).id)
			_client.send_text("message Resieved")
	elif state == WebSocketPeer.STATE_CLOSING:
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = _client.get_close_code()
		var reason = _client.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false) # Stop processing.
