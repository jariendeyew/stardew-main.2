extends Line2D
class_name JianQi

@export var length := 8
@export var target:Marker2D

var player:Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	clear_points()
	
func _process(delta: float) -> void:
	if player.player_direction == Vector2.LEFT:
		material.set_shader_parameter("flip_h",true)
	else:
		material.set_shader_parameter("flip_h",false)
	var target_position = to_local(target.global_position)
	#例如，它适合于确定子节点的位置，但不适合于确定其自身相对于父节点的位置。
	#target.position和to_local(target.global_position)本来意思是差不多的，但是前者会忽略父节点的旋转缩放变化，也就是不变
	#后者通过转换则会考虑到父节点的相关变化，而后面在种植作物代码和放置Placeable代码也会用到相关坐标转换
	add_point(target_position)
	if points.size() > length: #超过8个点时，删除第一个点
		remove_point(0)
		
#一个想法：line2d的texture直接是weapon的texture，然后再shader模糊处理，这样每把武器都有各自不同的刀光
