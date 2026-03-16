class_name PlayerStateIdle extends PlayerState

# what happens when the state is initialized
func init() -> void:
	pass
	
# what happen when you enter this state
func enter() -> void:
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
	return next_state
