extends Area2D
class_name ClickAreaComponent

signal mouse_right_click

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	input_event.connect(_on_input_event)


func _on_mouse_entered() -> void:
	MouseCursor.set_mouse_entered_cursor()

func _on_mouse_exited() -> void:
	MouseCursor.set_default_cursor()
	
	
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("mouse_right"):
		mouse_right_click.emit()
