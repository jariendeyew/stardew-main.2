extends Line2D


func _ready() -> void:
	clear_points()
	
func _process(delta: float) -> void:
	#add_point(get_local_mouse_position())
	add_point(get_parent().global_position)
	#prints(global_position,get_parent().global_position)
	if points.size()>20:
		remove_point(0)
