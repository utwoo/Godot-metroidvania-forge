extends Node

const slots : Array[ String ] = [ "save1", "save2", "save3" ]

var current_slot : int = 0

func create_new_game_save():
	var save_data = SaveData.new()
	# Scene Info
	save_data.scene_path = "uid://cilmdg5tpbdkk"
	# Player Info
	var player_info : PlayerInfo = PlayerInfo.new()
	player_info.global_position = Vector2(80, 260)
	player_info.current_hp = 1
	player_info.max_hp = 3
	save_data.player_info = player_info
	
	ResourceSaver.save(save_data, get_file_path(), ResourceSaver.FLAG_COMPRESS)
	print("save data")


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_F5:
			save_game()
		elif event.keycode == KEY_F9:
			load_game()
		elif event.keycode == KEY_1:
			current_slot = 0
		elif event.keycode == KEY_2:
			current_slot = 1
		elif event.keycode == KEY_3:
			current_slot = 2
			
func save_game():
	var save_data = SaveData.new()
	# Scene Info
	save_data.scene_path = SceneManager.current_scene_uid
	# Player Info
	var player : Player = get_tree().get_first_node_in_group("Player")
	var player_info : PlayerInfo = PlayerInfo.new()
	player_info.global_position = player.global_position
	player_info.current_hp = player.hp
	player_info.max_hp = player.max_hp
	save_data.player_info = player_info
	
	ResourceSaver.save(save_data, get_file_path(), ResourceSaver.FLAG_COMPRESS)
	pass

func load_game():
	var save_data : SaveData = ResourceLoader.load( get_file_path() )
	SceneManager.transition_scene( save_data.scene_path, "", Vector2.ZERO, "up" )
	await SceneManager.new_scene_ready
	
	# Set player status
	var player : Player = null
	while not player:
		player = get_tree().get_first_node_in_group( "Player" )
		await get_tree().physics_frame
		
	player.global_position = save_data.player_info.global_position
	player.hp = save_data.player_info.current_hp
	player.max_hp = save_data.player_info.max_hp
	pass
	
func get_file_path():
	return "user://%s.tres" % [ slots[current_slot] ]
