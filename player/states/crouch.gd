class_name PlayerStateCrouch
extends PlayerState

@export var deceleration_rate : float = 10.0

@onready var sprite: Sprite2D = $Sprite2D

# What happen when we initialize this state
func init() -> void:
	pass
	
# What happen when the player enters this state
func enter() -> void:
	player.animation_player.play("crouch")
	player.collision_stand.disabled = true
	player.collision_crouch.disabled = false
	pass

# What happen when the player exits this state
func exit() -> void:
	player.collision_stand.disabled = false
	player.collision_crouch.disabled = true
	pass

# What happen during the _process update in this state
func process( _delta : float ) -> PlayerState:
	if player.direction.y <= 0:
		return idle
	return null

# What happen during the _physics_process update in this state
func physics_process( _delta : float ) -> PlayerState:
	player.velocity.x -= player.velocity.x * deceleration_rate * _delta
	if not player.is_on_floor():
		return fall
	return null

# What happen with input events update in this state	
func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_pressed("jump"):
		player.one_way_platform_shape_cast.force_shapecast_update()
		if player.one_way_platform_shape_cast.is_colliding():
			player.position.y += 4.0
			return fall
		return jump
	return null
