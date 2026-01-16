extends CharacterBody2D
class_name Player
## 只用于选择Item和此Item对应的动画和状态，其他的功能通过额外组件来实现

@onready var hit_component: HitComponent = $HitComponent
@onready var weapon: Sprite2D = $Weapon/Weapon
@onready var jian_qi: JianQi = $Weapon/JianQi
@onready var effects: AnimatedSprite2D = $Effects
@onready var place_component: PlaceComponent = $PlaceComponent
@onready var state_machine: StateMachine = $StateMachine

@export var bag_system: InventorySystem
@export var swing_sfx: AudioStream
@export var axe_attack_rate: float = 0.4  # 斧头连砍速率
@export var draft_attack_rate: float = 0.4  # 稿子连砍速率
@export var hoe_attack_rate: float = 0.4  # 锄头连砍速率

@export var current_item: Item :
	set(val):
		current_item = val
		if val:
			current_item_type = val.type
			handle_selected_item(val)
		else:
			current_item_type = Item.ItemType.None
@export var current_item_type: Item.ItemType = Item.ItemType.None

signal watering
signal get_item  # 拾取物品信号

var items = null
var item_index: int = 0:  # current_item对应的下标
	set(val):
		item_index = val
		current_item = items[item_index] if item_index < items.size() else null

static var direction: Vector2 = Vector2.ZERO  # 共享移动方向
var player_direction: Vector2  # 记住最后移动方向
var can_move: bool = true

var ground: TileMapLayer
var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2
var distance: float

# 工具连砍Timer（一个字典，便于管理多个工具）
var tool_timers: Dictionary = {}

func _ready() -> void:
	bag_system.items.resize(bag_system.items_size)
	items = bag_system.items
	weapon.hide()
	weapon.offset = Vector2(12, -12)
	weapon.flip_h = false
	weapon.position = Vector2(0, -12)
	jian_qi.hide()
	effects.hide()
	player_direction = Vector2.DOWN
	setup_tool_timers()  # 创建所有Timer
	initial()
	SceneManager.level_changed.connect(initial)

# 设置所有工具Timer
func setup_tool_timers() -> void:
	tool_timers["Axe"] = create_timer("AxeTimer", axe_attack_rate)
	tool_timers["Draft"] = create_timer("DraftTimer", draft_attack_rate)
	tool_timers["Hoe"] = create_timer("HoeTimer", hoe_attack_rate)

func create_timer(name: String, wait_time: float) -> Timer:
	var timer = Timer.new()
	timer.name = name
	timer.one_shot = true
	timer.wait_time = wait_time
	add_child(timer)
	return timer

# 更新速率（编辑器改时生效）
func _set(property: StringName, value: Variant) -> bool:
	match property:
		"axe_attack_rate": tool_timers["Axe"].wait_time = value; return true
		"draft_attack_rate": tool_timers["Draft"].wait_time = value; return true
		"hoe_attack_rate": tool_timers["Hoe"].wait_time = value; return true
	return false

func initial() -> void:
	ground = get_tree().get_first_node_in_group("TileMap")

func _process(_delta: float) -> void:
	if !effects.is_playing():
		effects.hide()

func _physics_process(_delta: float) -> void:
	if can_move:
		direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if !current_item: return  # 防null崩溃
	
	# 通用工具持键连砍（Axe/Draft/Hoe）
	var tool_state = get_tool_state(current_item_type)
	if tool_state && Input.is_action_pressed("mouse_left") && tool_timers[tool_state].is_stopped():
		state_machine.transition_state(tool_state)
		tool_timers[tool_state].start()

# 获取工具状态名
func get_tool_state(type: Item.ItemType) -> String:
	match type:
		Item.ItemType.Axe: return "Axe"
		Item.ItemType.Draft: return "Draft"
		Item.ItemType.Hoe: return "Hoe"
	return ""

func handle_selected_item(item: Item) -> void:
	if !item: return
	var coll = hit_component.get_child(0) as CollisionShape2D
	coll.shape.extents = item.collision_size if item.collision_size != Vector2.ZERO else Vector2(8, 8)
	
	match item.type:
		Item.ItemType.Weapon: weapon.texture = item.texture
		Item.ItemType.Placeables: place_component.item_to_place = item
		Item.ItemType.Consume: pass
		Item.ItemType.Water: pass  # 水在_unhandled_input

func show_water_effects() -> void:
	get_cell_under_mouse()
	if !effects.visible && distance <= 40:
		effects.global_position = local_cell_position
		watering.emit(local_cell_position)
		effects.show()
		effects.play("water")

func get_cell_under_mouse() -> void:
	if !ground: return
	mouse_position = ground.get_local_mouse_position()
	cell_position = ground.local_to_map(mouse_position)
	cell_source_id = ground.get_cell_source_id(cell_position)
	local_cell_position = ground.map_to_local(cell_position)
	distance = global_position.distance_to(local_cell_position)

func _unhandled_input(event: InputEvent) -> void:
	if !current_item: return
	if event.is_action_pressed("mouse_left"):
		match current_item_type:
			Item.ItemType.Water:
				state_machine.transition_state("Water")
				show_water_effects()
			Item.ItemType.Weapon:
				state_machine.transition_state("Swing")
				AudioManager.play_sfx(swing_sfx)
				if current_item.name == "喵刀":
					var projectile = load("res://Bag/projectiles/rainbow_cat.tscn").instantiate() as Node2D
					get_tree().root.add_child(projectile)
					projectile.global_position = global_position
				if current_item.name == "暗影焰刀":
					var projectile = load("res://Bag/projectiles/暗影焰刀.tscn").instantiate() as Node2D
					get_tree().root.add_child(projectile)
					projectile.global_position = global_position
			Item.ItemType.None: print("没有物品")
			_: print("没有对应类型")
