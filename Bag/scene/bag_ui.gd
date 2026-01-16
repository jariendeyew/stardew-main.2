extends Control


@onready var grid_container: GridContainer = %GridContainer


@export var mouse_item:Control
@export var box_ui:Control

var player:Player = null
var slots:Array = []
var bag_system:InventorySystem = null 
var items = null


func _ready() -> void:	
	initial()
	SceneManager.level_changed.connect(initial)
	slots = grid_container.get_children()
	bag_system.item_changed.connect(update_slots) 
	update_slots()
	for slot_index in slots.size():
		slots[slot_index].slot_click.connect(on_slot_click.bind(slot_index))
		slots[slot_index].shift_slot_click.connect(on_shift_slot_click.bind(slot_index))
		slots[slot_index].slot_click_right.connect(on_slot_click_right.bind(slot_index))
		slots[slot_index].ctrl_slot_click.connect(on_ctrl_slot_click.bind(slot_index))

	
func initial() -> void:
	player = get_tree().get_first_node_in_group("Player")
	bag_system = player.bag_system #接下来就是让bag_ui去访问player中的inventory
	items = bag_system.items
	
func update_slots() ->void:
	for index in items.size():
		slots[index].set_item(items[index])

func on_slot_click(index) -> void:
	bag_system.swap_item(index)
	mouse_item.set_item(MouseItem.mouse_item)
	update_slots()

func on_shift_slot_click(index) ->void:
	if !box_ui.visible: return
	var temp_item = items[index]
	bag_system.remove_item(index)
	box_ui.box_system.add_item(temp_item)
	update_slots()

func on_slot_click_right(index) -> void:
	#右键只取一个
	bag_system.swap_one_item(index)
	mouse_item.set_item(MouseItem.mouse_item)
	update_slots()

func on_ctrl_slot_click(index) -> void:
	#ctrl左键取一半
	bag_system.swap_half_item(index)
	mouse_item.set_item(MouseItem.mouse_item)
	update_slots()#取一半
