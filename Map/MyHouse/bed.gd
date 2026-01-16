extends Area2D

const SAVE_TOOL_TIP = preload("res://UI/save_tool_tip.tscn")
var main_scene_level_root:String = "/root/MainScene"

func _ready() -> void:
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	
func on_body_entered(body:Node2D) -> void:
	if body is Player:
		var save_tool_tip = SAVE_TOOL_TIP.instantiate() as Control
		var pop_up = get_node(Global.root_scene["pop_up"])
		pop_up.add_child(save_tool_tip)
		
func on_body_exited(body:Node2D) -> void:
	if body is Player:
		var pop_up = get_node(Global.root_scene["pop_up"])
		for child in pop_up.get_children():
			var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
			tween.tween_property(child,"global_position",Vector2(0,740),0.5)
			await get_tree().create_timer(0.5).timeout	
			child.queue_free()
