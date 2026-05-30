@icon("res://assets/icons/state.svg")
class_name PlayerState
extends Node

var player : Player
var next_state : PlayerState

#region state references
@onready var idle: PlayerStateRun = %Idle
@onready var run: PlayerStateIdle = %Run
@onready var jump: PlayerStateJump = %Jump
@onready var fall: PlayerStateFall = %Fall
@onready var crouch: PlayerStateCrouch = %Crouch
#endregion

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
	return next_state

# What happen during the _physics_process update in this state
func physics_process( _delta : float ) -> PlayerState:
	return next_state

# What happen with input events update in this state	
func handle_input( _event : InputEvent ) -> PlayerState:
	return next_state
