class_name PlayerStateFall extends PlayerState

@export var coyote_time: float = 0.125
@export var fall_gravity_multiplier: float = 1.165
@export var jump_buffer_time: float = 0.2

var coyote_timer: float = 0.0
var buffer_timer: float = 0.0

# what happens when the state is initialized
func init() -> void:
	pass
	
# what happen when you enter this state
func enter() -> void:
	player.animation_player.play("jump")
	player.animation_player.pause()
	player.gravity_multiplier = fall_gravity_multiplier
	if player.previous_state == jump:
		coyote_timer = 0.0
	else:
		coyote_timer = coyote_time
	pass
	
# what happens when you exit this state
func exit() -> void:
	player.gravity_multiplier = 1.0
	pass
	
# what happens when an input is pressed?
func handle_inputs(_event: InputEvent) -> PlayerState:
	if _event.is_action_pressed("jump"):
		if coyote_timer > 0.0:
			return jump
		else:
			buffer_timer = jump_buffer_time
	return next_state
	
# what happens during the process loop
func process(_delta: float) -> PlayerState:
	set_jump_frame()
	coyote_timer -= _delta
	buffer_timer -= _delta
	return next_state

# what happens during the physics loop	
func physics_process(_delta: float) -> PlayerState:
	if player.is_on_floor():
		#player.add_debug_indicator(Color.RED)
		if buffer_timer > 0:
			return jump
		return idle
	player.velocity.x = player.direction.x * player.move_speed
	return next_state

func set_jump_frame() -> void:
	var frame: float = remap(player.velocity.y, 0.0, player.max_fall_velocity, 0.5, 1.0)
	player.animation_player.seek(frame, true)
	pass
