class_name PlayerStateFall extends PlayerState

# what happens when the state is initialized
func init() -> void:
	pass
	
# what happen when you enter this state
func enter() -> void:
	# play animation
	pass
	
# what happens when you exit this state
func exit() -> void:
	pass
	
# what happens when an input is pressed?
func handle_inputs(_event: InputEvent) -> PlayerState:
	return next_state
	
# what happens during the process loop
func process(_delta: float) -> PlayerState:
	return next_state

# what happens during the physics loop	
func physics_process(_delta: float) -> PlayerState:
	if player.is_on_floor():
		player.add_debug_indicator(Color.RED)
		return idle
	player.velocity.x = player.direction.x * player.move_speed
	return next_state
