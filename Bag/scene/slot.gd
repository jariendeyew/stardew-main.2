extends Control

const TOOL_TIP = preload("res://UI/tool_tip.tscn")

@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var label: Label = $MarginContainer/Label


var item:Item = null
var tool_tip_show:bool
var tool_tip:ToolTip

signal slot_click
signal shift_slot_click
signal slot_click_right
signal ctrl_slot_click

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	tool_tip_show = false	
	tool_tip = get_tree().get_first_node_in_group("ToolTip")
	

func _process(delta: float) -> void:
	if MouseItem.mouse_item:
		tool_tip.hide()
	if tool_tip_show and item!=null :
		tool_tip.set_item(item)
		tool_tip.show()
		tool_tip.global_position = get_global_mouse_position() + Vector2(10,10)
		tool_tip.adjust_tool_tip_position()
		
func set_item(item:Item) ->void:
	self.item = item
	if item != null:
		texture_rect.texture = item.texture
		if item.countable and item.quantity > 1:
			label.text = str(item.quantity)
		else:
			label.text = ""
	else:
		texture_rect.texture = null
		label.text = ""

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		if Input.is_key_pressed(KEY_SHIFT):
			shift_slot_click.emit()
		elif Input.is_key_pressed(KEY_CTRL):
			ctrl_slot_click.emit()
		else:
			slot_click.emit()#这些都是自定义的信号，左键单击等
	if event.is_action_pressed("mouse_right"):
		slot_click_right.emit()
		
func _on_mouse_entered() -> void:
	tool_tip_show = true
	
func _on_mouse_exited() -> void:
	tool_tip_show = false
	tool_tip.hide()
	
