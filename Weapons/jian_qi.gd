extends Line2D
class_name JianQi

@export var length: int = 8
@export var target: Marker2D

@onready var player: Player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	clear_points()

func _process(_delta: float) -> void:  # delta 未用
	match player.last_direction:
		Vector2.LEFT:
			material.set_shader_parameter("flip_h", true)
		_:
			material.set_shader_parameter("flip_h", false)
	
	var target_position = to_local(target.global_position)
	add_point(target_position)
	
	if points.size() > length:
		remove_point(0)
