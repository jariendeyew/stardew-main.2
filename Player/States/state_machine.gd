extends Node
class_name StateMachine

@export var initial_state: State
var current_state: State

func _ready() -> void:
	for state in get_children():
		if state is State:
			state.transition_to.connect(transition_state)
	if initial_state:
		current_state = initial_state
		current_state._enter()

func _physics_process(delta: float) -> void:
	if current_state:
		current_state._physics_update(delta)

func transition_state(next_state_name: String) -> void:
	var next_state: State = get_node_or_null(next_state_name)
	if not next_state or current_state == next_state:
		return
	current_state._exit()
	current_state = next_state
	current_state._enter()
