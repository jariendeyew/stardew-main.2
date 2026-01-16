extends Control
#AutoLoad MouseItem



var mouse_item:Item = null:
	set(val):
		player.current_item = val
		mouse_item = val
var player:Player

func _ready() -> void:
	initial()
	SceneManager.level_changed.connect(initial)

func initial():
	player = get_tree().get_first_node_in_group("Player")
	
func _process(_delta: float) -> void:
	if !mouse_item:
		global_position = get_global_mouse_position()+Vector2(8,8)
	else:
		global_position = Vector2.ZERO
	#由于这个现在是和背包UI独立的节点，所以他的位置更新直接写在他自己的脚本里

func set_item(item:Item) -> void:
	var texture_rect: TextureRect = $MarginContainer/TextureRect
	var label: Label = $MarginContainer/Label
	if item != null :
		texture_rect.texture = item.texture
		if item.quantity <= 1:
			label.text = ""
		else:
			label.text = str(item.quantity)
	else:
		texture_rect.texture = null
		label.text = ""


#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("mouse_right"):
		#if mouse_item:
			#var item_ins = preload(item_scene).instantiate()
			#item_ins.global_position = player.global_position
			#get_tree().root.add_child(item_ins)
