extends Node
## Autoload，用于存储常量、

const TOOL_TIP = preload("res://UI/tool_tip.tscn")
const FALL_OBJECT_COMPONENT = preload("res://FallObjects/fall_object_component.tscn")

var root_scene:Dictionary = { ##"main_scene""main_canvas_layer""pop_up""levels""drops""ui_manager"
	"main_scene": "/root/MainScene",
	"main_canvas_layer":"/root/MainScene/MainCanvasLayer",
	"pop_up":"/root/MainScene/MainCanvasLayer/PopUp",
	"levels":"/root/MainScene/Levels",
	"drops":"/root/MainScene/Levels/Drops",
	"ui_manager":"/root/MainScene/MainCanvasLayer/UIManager",
}
