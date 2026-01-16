extends CanvasModulate
class_name TimeColor

var weeks:Array = ["星期一","星期二","星期三","星期四","星期五","星期六","星期天"]

@export var init_day:int:
	set(val):
		init_day = val
		TimeSystem.initial_day = val
		TimeSystem.set_initial_time()
		
@export var init_hour:int:
	set(val):
		init_hour = val
		TimeSystem.initial_hour = val
		TimeSystem.set_initial_time()
		
@export var init_minite:int:
	set(val):
		init_minite = val
		TimeSystem.initial_minute = val
		TimeSystem.set_initial_time()
		
@export_range(0,6) var init_week:int:
	set(val):
		init_week = val
		TimeSystem.inital_week = weeks[val]
		
@export var day_night_gradient:GradientTexture1D

func _ready() -> void:
	TimeSystem.game_time.connect(on_game_time)
	
func on_game_time(time:float):
	#设置滤镜,下面这一堆数值计算会让sample_value值在0-1变化,对应的是0-12小时
	var sample_value = 0.5 * (sin(time - PI * 0.5) + 1.0) #让滤镜和time时间对应
	color = day_night_gradient.gradient.sample(sample_value) 
