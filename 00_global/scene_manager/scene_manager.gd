extends Node

signal load_scene_started
signal new_scene_ready( target_name : String, offset : Vector2 )
signal load_scene_finished

@onready var fade: Control = $fade

func _ready() -> void:
	fade.hide()
	await get_tree().physics_frame
	load_scene_finished.emit()
	pass

func transition_scene( target_level : String, target_area : String, player_offset : Vector2, direction : String ):
	
	get_tree().paused = true
		
	load_scene_started.emit()
	
	# fade out
	fade.show()
	
	var fade_position := get_fade_position(direction)
	await fade_screen( fade_position, Vector2.ZERO )
	
	get_tree().change_scene_to_file( target_level )
	
	await get_tree().scene_changed
	
	new_scene_ready.emit( target_area, player_offset )
	
	# fade new scene in
	await fade_screen( Vector2.ZERO, -fade_position )
	fade.hide()
	
	get_tree().paused = false
	
	load_scene_finished.emit()
	
	pass
	

func fade_screen( from : Vector2, to : Vector2 ):
	fade.position = from
	var tween := create_tween()
	tween.tween_property( fade, "position", to, 0.2 )
	await tween.finished
	
	
func get_fade_position( direction : String ) -> Vector2:
	var position := Vector2( 480 * 2, 270 * 2 )
	
	match direction:
		"left":
			position *= Vector2( -1, 0 )
		"right":
			position *= Vector2( 1, 0 )
		"up":
			position *= Vector2( 0, -1 )
		"down":
			position *= Vector2( 0, 1 )
	
	return position
