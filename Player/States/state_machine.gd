extends Node
class_name StateMachine

@export var initial_state: State  # 初始状态
var current_state: State

func _ready() -> void:
	for state in get_children():
		if state is State:
			state.transition_to.connect(transition_state)
			#给每个状态连接转换信号
	# 初始化进入第一个状态
	if initial_state:
		current_state = initial_state
		current_state._enter()
	
	
func _physics_process(delta: float) -> void:
	#每物理帧执行当前状态，State状态的执行在StateMachine状态机中，一次只能执行一个
	current_state._physics_update(delta)
	
func transition_state(next_state_name:String):
	# 切换状态的方法
	var next_state:State=get_node(next_state_name)#从子节点获取切换的节点
	print(next_state_name)
	if !next_state:return
	if current_state == next_state : return #状态不同才转换
	current_state._exit()
	current_state = next_state
	next_state._enter()
		
