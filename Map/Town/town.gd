extends Node2D
class_name Town

@onready var lights: Node2D = $Light

@export var bg_music1:AudioStream
@export var bg_music2:AudioStream #夜晚

func _ready() -> void:
	lights.hide()
	TimeSystem.time_tick.connect(func(day,hour,minute,week):
		if hour >= 18 and hour<=24:
			lights.show()
			AudioManager.play_music(bg_music2)
		)
	AudioManager.play_music(bg_music1)

		
	
