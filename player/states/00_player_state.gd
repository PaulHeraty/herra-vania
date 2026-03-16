@icon("res://player/states/state.svg") 
class_name PlayerState extends Node

var player: Player
var next_state: PlayerState

#region /// state references
# reference to all other states
#endregion

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
	
