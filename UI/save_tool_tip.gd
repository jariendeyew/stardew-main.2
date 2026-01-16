extends Control

@onready var ok: Button = $MarginContainer/VBoxContainer/Ok
@onready var cancel: Button = $MarginContainer/VBoxContainer/Cancel


func _ready() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self,"global_position",Vector2(0,424),0.5)
	ok.pressed.connect(ok_pressed)
	cancel.pressed.connect(cancel_pressed)
	
func ok_pressed() -> void:
	SaveManager._save()
	
func cancel_pressed() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self,"global_position",Vector2(0,740),0.5)
	await get_tree().create_timer(0.5).timeout
	queue_free()
