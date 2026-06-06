class_name PlayerStateFall
extends PlayerState

@export var coyote_time : float = 0.1
@export var jump_buffer_time : float = 0.1
@export var fall_gravity_mulitplier : float = 1.165

var coyote_timer : float = 0
var jump_buffer_timer : float = 0

# What happen when we initialize this state
func init() -> void:
	pass
	
# What happen when the player enters this state
func enter() -> void:
	player.animation_player.play("jump")
	player.animation_player.pause()
	# change fall gravity
	player.gravity_mulitplier = fall_gravity_mulitplier
	# set coyote time
	if player.previous_state != jump:
		coyote_timer = coyote_time
	pass

# What happen when the player exits this state
func exit() -> void:
	player.gravity_mulitplier = 1.0
	pass

# What happen during the _process update in this state
func process( _delta : float ) -> PlayerState:
	coyote_timer -= _delta
	jump_buffer_timer -= _delta
	set_jump_frame()
	return next_state

# What happen during the _physics_process update in this state
func physics_process( _delta : float ) -> PlayerState:
	if player.is_on_floor():
		if jump_buffer_timer > 0.0:
			return jump
		return idle
		
	player.velocity.x = player.direction.x * player.move_speed
	return next_state

# What happen with input events update in this state	
func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_pressed("jump"):
		if coyote_timer > 0:
			return jump
		else:
			jump_buffer_timer = jump_buffer_time

	return next_state
	
func set_jump_frame():
	var frame : float = remap( player.velocity.y, 0.0, player.max_fall_velocity, 0.5, 1.0 )
	player.animation_player.seek( frame, true )
	pass
