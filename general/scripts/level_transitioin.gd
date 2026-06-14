@tool
@icon("res://general/icons/level_transition.svg")
class_name LevelTransition
extends Node2D

enum SIDE { LEFT, RIGHT, TOP, BOTTOM }

@export_range( 2, 20, 1, "or_greater") var size : int = 2 :
	set( value ):
		size = value
		apply_area_settings()

@export var location : SIDE = SIDE.LEFT :
	set( value ):
		location = value
		apply_area_settings()

@export_file("*.tscn") var target_level : String = ""
@export var target_area_name : String = "LevelTransition"

@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	SceneManager.new_scene_ready.connect( _on_new_scene_ready )
	SceneManager.load_scene_finished.connect( _on_load_scene_finished )
	
	apply_area_settings()
	pass

func apply_area_settings():
	## 在属性值的setter中调用该方法，但此时全局属性的area_2d(@ready)此时还没有赋值
	## 所以要通过节点树去获取。
	#area_2d = get_node_or_null("Area2D")

	if not area_2d:
		return

	if location == SIDE.LEFT or location == SIDE.RIGHT:
		area_2d.scale.y = size
		if location == SIDE.LEFT:
			area_2d.scale.x = -1
		else:
			area_2d.scale.x = 1
	else:
		area_2d.scale.x = size
		if location == SIDE.TOP:
			area_2d.scale.y = 1
		else:
			area_2d.scale.y = -1
	
func _on_body_entered( player : Node2D ):
	if player is Player:
		SceneManager.transition_scene( target_level, target_area_name, get_offset(player), get_transition_direction(location) )
	pass

func _on_new_scene_ready( target_name : String, offset : Vector2  ):
	if target_name == name:
		var player : Node2D = get_tree().get_first_node_in_group("Player")
		player.global_position = global_position + offset
	pass
	
func _on_load_scene_finished():
	area_2d.monitoring = false
	area_2d.body_entered.connect( _on_body_entered )
	await get_tree().physics_frame
	await get_tree().physics_frame
	area_2d.monitoring = true
	pass

func get_offset( player : Node2D ) -> Vector2:
	var offset := Vector2.ZERO
	
	if location == SIDE.LEFT or location == SIDE.RIGHT:
		offset.y = player.global_position.y - self.global_position.y
		if location == SIDE.LEFT:
			offset.x = -12
		else:
			offset.x = 12
	else:
		if location == SIDE.TOP or location == SIDE.BOTTOM:
			offset.y = player.global_position.x - self.global_position.x
			if location == SIDE.TOP:
				offset.y = -2
			else:
				offset.y = 48
	return offset
	
func get_transition_direction( _location : SIDE ) -> String:
	match _location:
		SIDE.LEFT:
			return "left"
		SIDE.RIGHT:
			return "right"
		SIDE.TOP:
			return "up"
		SIDE.BOTTOM:
			return "down"
	
	return "left"
