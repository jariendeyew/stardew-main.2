extends Control

@onready var h_box_container: HBoxContainer = %HBoxContainer
@onready var selector: TextureRect = %Selector
@onready var margin_container: MarginContainer = %MarginContainer

@export var shotcut:Shortcut

var player : Player = null
var slots = null
var bag = null
var items = null
var selected_index:int = 0

func _ready() -> void:
	initial()
	SceneManager.level_changed.connect(initial)
	slots = h_box_container.get_children()
	update_slots()
	bag.item_changed.connect(update_slots)
	for slot_index in slots.size():
		slots[slot_index].slot_click.connect(on_slot_click.bind(slot_index))
	
func initial():
	player = get_tree().get_first_node_in_group("Player")
	bag = player.bag_system
	items = bag.items

func update_slots() -> void:
	for index in items.size()/3:
		slots[index].set_item(items[index]) #工具栏渲染背包系统的第一行
	
func on_slot_click(new_index) -> void:
	#点击之后有红框选中效果，并且bag_ui上的对应下标数字也会变红。
	selected_index = new_index
	set_selector()
	equip_item(selected_index)
	
func set_selector() -> void: #这里selected_index能记录改变，但是visible改变之后selector会变原样
	#根据selected_index选中selector
	selector.global_position.x = slots[selected_index].global_position.x #global_position就是我们看到的位置，position不会算边距值
	equip_item(selected_index)
	
func _input(event: InputEvent) -> void:
	for i in shotcut.events.size():
		if event is InputEventKey and event.pressed :
			if event.keycode == shotcut.events[i].keycode:
				selected_index = i
				break
	if event.is_action_pressed("scroll_down"):
		selected_index = (selected_index+1)%12
	elif event.is_action_pressed("scroll_up"):
		selected_index = (selected_index-1)%12


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("drop"): #扔东西
		if items[selected_index] != null:
			add_fall_objects(1,items[selected_index])
			player.bag_system.remove_item(selected_index)

func equip_item(index) -> void:
	player.current_item = items[index]
	player.item_index = index
	player.hit_component.current_item_type = player.current_item_type
	
func add_fall_objects(num:int,item:Item) -> void: #bug原因：吸附的优先级高于动画
	for i in range(num):
		var fall_ins = Global.FALL_OBJECT_COMPONENT.instantiate()
		var drops = get_tree().root.get_node_or_null(Global.root_scene["drops"]) as Node2D
		if !drops:
			drops = get_tree().root
		fall_ins.position = player.global_position
		drops.add_child(fall_ins)
		fall_ins.is_bezier = true
		fall_ins.generate(item)
		
