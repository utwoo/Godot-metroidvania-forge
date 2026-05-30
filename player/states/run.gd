class_name PlayerStateIdle
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
	if player.direction.x == 0:
		return idle
	elif player.direction.y > 0:
		return crouch
	return next_state

# What happen during the _physics_process update in this state
func physics_process( _delta : float ) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed 
	if not player.is_on_floor():
		return fall 
	return next_state

# What happen with input events update in this state
func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_pressed("jump"):
		return jump
	return next_state
