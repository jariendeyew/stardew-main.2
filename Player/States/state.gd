extends Node
class_name State

@warning_ignore("unused_signal")
signal transition_to(state_name:String)

# 每个状态都需要这些功能：
#下划线是虚函数，可被继承重写
func _enter():
	pass# 进入这个状态时要做什么（比如播放动画）,播放一次的就在这里执行，循环播放就在physics_update执行
	
func _exit():
	pass# 离开这个状态时要做什么
	
func _physics_update(delta):
	pass# 物理帧更新时做什么（比如移动计算），转换条件判断也在这里
	
func _update(delta):
	pass #每帧更新，通常是粒子特效等操作

func _update_animation():
	pass #执行对应状态动画
