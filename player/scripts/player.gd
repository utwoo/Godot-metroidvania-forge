class_name Player
extends CharacterBody2D

#region State Machine Variables
var states : Array[ PlayerState ]
var current_state : PlayerState :
	get : return states.front()
var previous_state : PlayerState :
	get : return states[ 1 ]
#endregion

#region Standard Variables
var direction : Vector2 = Vector2.ZERO
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
#endregion

func _ready() -> void:
	initialize_states()
	pass

func _process(delta: float) -> void:
	change_state( current_state.process( delta ) )
	pass

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	change_state( current_state.physics_process( delta ) )
	move_and_slide()
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	change_state( current_state.handle_input( event ) )
	pass

func initialize_states():
	states = []
	# gather all states
	for c in $States.get_children():
		if c is PlayerState:
			states.append( c )
			c.player = self
	
	if states.is_empty():
		return
	
	# initialize states
	for state in states:
		state.init()
		
	# set first state
	change_state( current_state )
	
	pass
	
func change_state( new_state : PlayerState ):
	if not new_state:
		return
	
	if new_state == current_state:
		return
		
	if current_state:
		current_state.exit()
		
	states.push_front( new_state )
	states.resize( 3 )
	new_state.enter()
	
func update_direction():
	direction = Input.get_vector( "left", "right", "up", "down" )
	pass
	
