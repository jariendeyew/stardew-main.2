extends Control
class_name ToolTip

@onready var item_name: Label = %ItemName
@onready var description: Label = %Description
@onready var nine_patch_rect: NinePatchRect = $NinePatchRect
@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer
@onready var margin_container: MarginContainer = $MarginContainer

#这个根节点的大小不会动态改变，所以只能获取marginContainer的相关参数
var screen_rect: Rect2  # 屏幕可视区域

func _ready() -> void:
	screen_rect = get_viewport().get_visible_rect()

func _process(delta: float) -> void:
	nine_patch_rect.size = margin_container.size/2
	margin_container.global_position = self.global_position
	margin_container.size = self.size
	#adjust_tool_tip_position()
	#global_position = get_global_mouse_position() + Vector2(8,8)

func set_item(item:Item) -> void:
	if item == null : return
	item_name.text = item.name
	description.text = item.description
	
func adjust_tool_tip_position():
	var pos = global_position
	# 检测右侧是否超出
	if pos.x + size.x > screen_rect.end.x: #end为矩形的右下角
		pos.x = screen_rect.end.x - size.x
	# 检测左侧是否超出
	if pos.x < screen_rect.position.x:
		pos.x = screen_rect.position.x
	#检测底部是否超出
	if pos.y + margin_container.size.y > screen_rect.end.y:
		pos.y = get_global_mouse_position().y - margin_container.size.y
	global_position = pos
	
