class_name PlayerStateJump extends PlayerState

@export var jump_velocity: float = 450.0

# what happens when the state is initialized
func init() -> void:
	pass
	
# what happen when you enter this state
func enter() -> void:
	# play animation
	player.add_debug_indicator(Color.LIME_GREEN)
	player.velocity.y = -jump_velocity
	pass
	
# what happens when you exit this state
func exit() -> void:
	player.add_debug_indicator(Color.YELLOW)
	pass
	
# what happens when an input is pressed?
func handle_inputs(_event: InputEvent) -> PlayerState:
	if _event.is_action_released("jump"):
		player.velocity.y *= 0.5
		return fall
	return next_state
	
# what happens during the process loop
func process(_delta: float) -> PlayerState:
	return next_state

# what happens during the physics loop	
func physics_process(_delta: float) -> PlayerState:
	if player.is_on_floor():
		return idle
	elif player.velocity.y >= 0.0:
		return fall
	player.velocity.x = player.direction.x * player.move_speed
	return next_state
