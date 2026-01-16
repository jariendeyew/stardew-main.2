extends Control


@onready var grid_container: GridContainer = %GridContainer


@export var mouse_item: Control

var player:Player  #bag和box互相依赖
var boxes:Array = []
var slots:Array = []
var box_system:InventorySystem = null 
var items = null
var box_name:String #有一个问题，box_name是在点击箱子之后才得到，所以bag和items赋值不能在ready

#多对一，一个box_ui对应多个bag，每次打开都是同一个box_ui只是读取的bag_system数据不同，这边同理通过name来判断打开的哪一个箱子
func _ready() -> void:	
	initial()
	SceneManager.level_changed.connect(initial)
	#信号的连接只需要一次
	slots = grid_container.get_children()
	for slot_index in slots.size():
		slots[slot_index].slot_click.connect(on_slot_click.bind(slot_index))
		slots[slot_index].shift_slot_click.connect(on_shift_slot_click.bind(slot_index))
		slots[slot_index].slot_click_right.connect(on_slot_click_right.bind(slot_index))
		slots[slot_index].ctrl_slot_click.connect(on_ctrl_slot_click.bind(slot_index))
	for box in boxes:
		box.box_opened.connect(on_box_opened)
		box.box_closed.connect(on_box_closed)	
	
func initial() -> void:
	player = get_tree().get_first_node_in_group("Player")
	boxes = get_tree().get_nodes_in_group("Boxes") #有很多个箱子，箱子的数据都各自独立。
	
	
func on_box_opened(name) -> void: #打开箱子触发的信号
	box_name = name #这是打开箱子就会有值，然后是使用box.name来和这个box_name对比
	for box in boxes:
		if box.name == box_name:
			#这里证明了两个箱子的Inventory本来就是互通的
			box_system = box.box_system #不能用duplicate，不然每次都会直接duplicate
			items = box_system.items
	box_system.item_changed.connect(update_slots) #每次打开都会连接，这是bug，下面要取消连接
	update_slots()
	
func on_box_closed() ->void:
	box_system.item_changed.disconnect(update_slots) #箱子关闭后关闭连接
	
func update_slots() ->void:
	for index in items.size():
		slots[index].set_item(items[index])

func on_slot_click(index) -> void:
	box_system.swap_item(index)
	mouse_item.set_item(MouseItem.mouse_item)
	update_slots()
	
func on_shift_slot_click(index) ->void:
	var temp_item = items[index]
	box_system.remove_item(index)
	player.bag_system.add_item(temp_item)
	update_slots()

func on_slot_click_right(index) -> void:
	#右键只取一个
	box_system.swap_one_item(index)
	mouse_item.set_item(MouseItem.mouse_item)
	update_slots()

func on_ctrl_slot_click(index) -> void:
	#ctrl左键取一半
	box_system.swap_half_item(index)
	mouse_item.set_item(MouseItem.mouse_item)
	update_slots()#取一半
