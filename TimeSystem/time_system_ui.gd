extends Control

@onready var hour_label: Label = %Hours
@onready var day_label: Label = %Day
@onready var week_label: Label = %Week
@onready var pointer: Sprite2D = $Pointer
		

func _ready() -> void:
	TimeSystem.time_tick.connect(on_time_tick)
	
	pointer.rotation = deg_to_rad(-180)
	
func on_time_tick(day:int,hour:int,minute:int,week) -> void:
	hour_label.text = "%02d:%02d" % [hour,minute]
	day_label.text = str(day)+"日"
	week_label.text = str(week)
	var tween = create_tween()
	tween.tween_property(pointer,"rotation",deg_to_rad(180/24*hour-180),4)
		

	
