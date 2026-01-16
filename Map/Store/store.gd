extends Node2D

@export var click_area_component: ClickAreaComponent

func _ready() -> void:
	click_area_component.mouse_right_click.connect(on_mouse_right_click)
	
func on_mouse_right_click() -> void:
	var ui_manager = get_node_or_null(Global.root_scene["ui_manager"])
	ui_manager.store_show = true
