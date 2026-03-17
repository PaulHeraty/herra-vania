class_name PlayerStateRun extends PlayerState

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
	if _event.is_action_pressed("jump"):
		return jump
	return next_state
	
# what happens during the process loop
func process(_delta: float) -> PlayerState:
	if player.direction.x == 0:
		return idle
	return next_state

# what happens during the physics loop	
func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed
	if player.is_on_floor() == false:
		return fall
	return next_state
