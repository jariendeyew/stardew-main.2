extends Control

@onready var tool_bar: Control = $ToolBar
@onready var bag_ui: Control = $BagUi
@onready var box_ui: Control = $BoxUi
@onready var store_panel: StorePanel = $StorePanel

#bag_ui通过按e实现开关，box_ui通过点击实现打开（bag_ui同时打开），再按e则都关闭，关闭时会播放动画。

var boxes:Array = []
var box_name:String
var player:Player
var store_show:bool = false:
	set(val):
		store_panel.visible = val
		store_show = val

func _ready() -> void:
	initial()
	SceneManager.level_changed.connect(initial)
	for box in boxes:#每个箱子都要连接信号
		box.box_opened.connect(on_box_opened)
		box.box_closed.connect(on_box_closed)
	
func initial() -> void:
	boxes = get_tree().get_nodes_in_group("Boxes")
	player = get_tree().get_first_node_in_group("Player")
	store_panel.visible = false
	bag_ui.visible = false
	box_ui.visible = false #赋值初始状态

		

func _process(_delta: float) -> void:
	tool_bar.visible = !bag_ui.visible
	if tool_bar.visible:
		tool_bar.set_selector()
		player.can_move = true
	else:
		player.can_move = false
	#商店开关
	if store_show:
		bag_ui.visible = true
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_bag") or event.is_action_pressed("Esc"):
		bag_ui.visible = !bag_ui.visible
		#下面是箱子的关闭触发，这里要关对于箱子已经打开的ui
		if box_ui.visible and !bag_ui.visible :
			for box in boxes:
				box.close_the_box(box_name) #关闭打开的那个箱子
		#商店关闭
		if store_panel.visible and !bag_ui.visible: #这里和上面一样!bag_ui.visible，我也不清楚为什么
			store_show = false

func on_box_opened(name) -> void:
	box_name = name #通过信号把名字发送出来，然后又通过参数传回去比较，来判断是否是同一个box
	bag_ui.visible = true #让bag跟随box打开
	box_ui.visible = true
	#同时box_ui为开启状态时，需要暂停游戏，bag_ui打开也一样
	
func on_box_closed() ->void:
	box_ui.visible = false


func _on_save_pressed() -> void:
	SaveManager._save()
	prints("save")


func _on_load_pressed() -> void:
	SaveManager._load()
	prints("load")


func _on_seven_pressed() -> void:
	var time_color = get_parent().get_parent().get_child(0) as TimeColor
	time_color.init_day +=1


func _on_night_pressed() -> void:
	var time_color = get_parent().get_parent().get_child(0) as TimeColor
	time_color.init_hour = 18


func _on_noon_pressed() -> void:
	var time_color = get_parent().get_parent().get_child(0) as TimeColor
	time_color.init_hour = 12
