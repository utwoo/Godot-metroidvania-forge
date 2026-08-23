class_name PlayerSpawn
extends Node2D

func _ready() -> void:
	visible = false
	await get_tree().process_frame
	
	if get_tree().get_first_node_in_group( "Player" ):
		return
	
	var player : Player = load("uid://cfa3xni5hj64u").instantiate()
	player.global_position = self.global_position 
	self.add_sibling( player )
