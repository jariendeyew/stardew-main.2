extends Node2D
class_name Farm

@export var bg_music1:AudioStream

func _ready() -> void:
	AudioManager.play_music(bg_music1)
	pass
