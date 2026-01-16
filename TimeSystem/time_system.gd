extends Node
#Autoload

#现实中一秒 == 游戏中一分钟
#现实中一分 == 游戏中一小时 ， 分钟*60
#现实中24分 == 游戏中一天 ， 小时 * 24
#本次需要星期、天数、小时、分钟

const MINUTES_PER_DAY : int  = 24 * 60 #每天的分钟数
const MINUTES_PER_HOUR : int = 60 #每小时分钟数
const GAME_MINUTE_DURATION: float = TAU / MINUTES_PER_DAY # TAU是PI*2 确保时间循环, 游戏中一分钟对应现实的时间
#这个常量在滤镜哪里有用

var game_speed:float = 1.0 #时间流速
var weeks:Array = ["星期一","星期二","星期三","星期四","星期五","星期六","星期天"]

var initial_day:int = 1
var initial_hour:int = 6
var initial_minute:int = 30
var inital_week = weeks[0]

var time:float = 0.0 #跟踪当前累计的游戏时间
var current_minute:int = -1
var current_day:int = 0

signal game_time(time:float)
signal time_tick(day:int,hour:int,minute:int,week) #每分钟变化时触发，传递分、小时、天
signal time_tick_day(day:int) #天数变化时触发，传递天,实际上定义信号时这些参数没用，真正的参数是发送信号时

func _ready() -> void:
	set_initial_time()
	
func _process(delta: float) -> void:
	#time += Time.get_ticks_msec()/1000 这会获得从引擎启动开始计算的时间
	#time += delta * game_speed#这大约会每秒加一，这个就是总时间，游戏中的分钟
	time += delta * game_speed * GAME_MINUTE_DURATION #和上面的多了一个周期循环，虽然不知道什么用，先留着
	game_time.emit(time)
	recalculate_time()
	#print(time)

func set_initial_time() -> void: #
	var initial_total_minutes = initial_day * MINUTES_PER_DAY + (initial_hour * MINUTES_PER_HOUR) + initial_minute #初始的游戏中总分钟数
	time = initial_total_minutes * GAME_MINUTE_DURATION #这个常量害人不浅

func recalculate_time() -> void: #这个函数的目的是从当前的 time 值（累计的虚拟游戏时间）计算出具体的“游戏时间”，包括天数、小时和分钟。
	var total_minutes:int = int(time / GAME_MINUTE_DURATION) #游戏中的虚拟分钟数，它将累计的 time 值除以 GAME_MINUTE_DURATION 来转换成“游戏分钟”单位。
	var current_day_minutes:int = int(total_minutes % MINUTES_PER_DAY) #当天总分钟数
	#下面是可直接调用的变量
	var day: int = int(total_minutes / MINUTES_PER_DAY) #总天数 = 总分钟数/(24 * 60)
	var hour: int = int(current_day_minutes / MINUTES_PER_HOUR) #一天的小时数 = 当天分钟数 / 60
	var minute:int = int(current_day_minutes % MINUTES_PER_HOUR) #一小时的分钟数
	var week = weeks[day%7 - 1]
	
	#if 语句确保只有在分钟或天数发生变化时，才发出time_tick或time_tick_day信号，避免不必要的重复调用。
	if current_minute != minute:
		current_minute = minute
		time_tick.emit(day,hour,minute,week) #将这些时间变量通过信号发送出去
		
	if current_day != day:
		current_day = day
		time_tick_day.emit(day) #上面传递了day，我目前猜测这个day是用于作物种植时传递
