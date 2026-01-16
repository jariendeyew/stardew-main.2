extends Node2D

@onready var line_2d: Line2D = $Line2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D

var player:Player
var i:int=0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	line_2d.clear_points()
	line_2d.add_point(Vector2.ZERO)
	line_2d.add_point(Vector2.ZERO)

func _process(delta:float) -> void:
	var start_pos :Vector2= Vector2.ZERO
	var direction = start_pos.direction_to(get_local_mouse_position())
	var screen_rect = get_viewport().get_visible_rect() #计算窗口边缘的位置
	var end_pos = start_pos + direction * max(screen_rect.size.x, screen_rect.size.y) * 2
	line_2d.points =[start_pos,end_pos]
	#var tween = create_tween()
	#tween.tween_property(line_2d,"points",[start_pos,end_pos],1)
	i+=1
	if i > (1/delta)*3:
		queue_free()
