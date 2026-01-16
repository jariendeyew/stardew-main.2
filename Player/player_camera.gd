extends Camera2D

func _ready() -> void:
	SceneManager.level_changed.connect(on_level_changed)
	zoom = Vector2(2,2)

func on_level_changed() -> void:
	var current_scene = SceneManager.get_current_level()
	#设置相机在不同场景下的表现状态，暂时不设置
	var maker_2d = current_scene.find_child("MapSize") as Marker2D
	if maker_2d != null:
		var map_size = maker_2d.global_position
		limit_left = 0
		limit_top = 0
		limit_right = map_size.x
		limit_bottom = map_size.y
	else:
		limit_left = -10000
		limit_top = -10000
		limit_right = 10000
		limit_bottom = 10000
