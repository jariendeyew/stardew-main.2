extends Node

@export var default_cursor:Texture2D
@export var mouse_entered_cursor:Texture2D

func _ready() -> void:
	set_default_cursor()

func set_default_cursor():
	Input.set_custom_mouse_cursor(default_cursor,Input.CURSOR_ARROW)

func set_mouse_entered_cursor():
	Input.set_custom_mouse_cursor(mouse_entered_cursor)
