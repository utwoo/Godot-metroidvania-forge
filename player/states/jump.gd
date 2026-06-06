class_name PlayerStateJump
extends PlayerState

@export var jump_velocity : float = 450.0

# What happen when we initialize this state
func init() -> void:
	pass
	
# What happen when the player enters this state
func enter() -> void:
	player.animation_player.play("jump")
	player.animation_player.pause()
	player.velocity.y = -jump_velocity
	pass

# What happen when the player exits this state
func exit() -> void:
	pass

# What happen during the _process update in this state
func process( _delta : float ) -> PlayerState:
	set_jump_frame()
	return next_state

# What happen during the _physics_process update in this state
func physics_process( _delta : float ) -> PlayerState:
	if player.is_on_floor():
		return idle
	elif player.velocity.y >= 0.0 :
		return fall
		
	player.velocity.x = player.direction.x * player.move_speed
	return next_state

# What happen with input events update in this state	
func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_released("jump"):
		player.velocity.y *= 0.5
	return next_state
	
func set_jump_frame():
	var frame : float = remap( player.velocity.y, -jump_velocity, 0.0, 0.0, 0.5 )
	player.animation_player.seek( frame, true )
	pass
