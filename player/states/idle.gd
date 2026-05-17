class_name PlayerStateRun
extends PlayerState

# What happen when we initialize this state
func init() -> void:
	pass
	
# What happen when the player enters this state
func enter() -> void:
	pass

# What happen when the player exits this state
func exit() -> void:
	pass

# What happen during the _process update in this state
func process( _delta : float ) -> PlayerState:
	if player.direction.x != 0:
		return run
	return next_state

# What happen during the _physics_process update in this state
func physics_process( _delta : float ) -> PlayerState:
	player.velocity.x = 0.0
	return next_state

# What happen with input events update in this state	
func handle_input( _event : InputEvent ) -> PlayerState:
	return next_state
