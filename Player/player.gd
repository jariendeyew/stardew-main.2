extends CharacterBody2D
class_name Player

@export_group("Mod Settings")  # mod 设置
@export var speed: float = 100.0  # 正常移速
@export var attack_rates: Dictionary = {"Axe": 0.4, "Draft": 0.4, "Hoe": 0.4}
@export var infinite_stamina: bool = false

@onready var hit_component: HitComponent = $HitComponent
@onready var weapon: Sprite2D = $Weapon/Weapon
@onready var jian_qi: Node2D = $Weapon/JianQi
@onready var effects_pool: Node2D = $EffectsPool
@onready var place_component: PlaceComponent = $PlaceComponent
@onready var state_machine: StateMachine = $StateMachine
@onready var raycast: RayCast2D = $MouseRay

@export var bag_system: InventorySystem
@export var swing_sfx: AudioStream

signal watering(pos: Vector2)
signal get_item

var items: Array = []
var item_index: int = 0:
	set(val):
		item_index = clamp(val, 0, items.size() - 1)
		current_item = items[item_index] if items.size() > 0 else null

var current_item: Item:
	set(val):
		current_item = val
		current_item_type = val.type if val else Item.ItemType.None
		if val: handle_selected_item(val)

var current_item_type: Item.ItemType = Item.ItemType.None

static var direction: Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.DOWN
var can_move: bool = true
var tool_cooldown: float = 0.0

var ground: TileMapLayer

var effect_pool: Array[GPUParticles2D] = []
var pool_size: int = 10

func _ready() -> void:
	bag_system.items.resize(bag_system.items_size)
	items = bag_system.items
	init_items()
	weapon.hide()
	setup_weapon()
	setup_pool()
	initial()
	SceneManager.level_changed.connect(initial)

func init_items() -> void:
	var tools_texture = preload("res://Art/tile_sheets/tools.png")
	bag_system.add_item(create_item("水壶", Item.ItemType.Water, tools_texture))
	bag_system.add_item(create_item("镰刀", Item.ItemType.Draft, tools_texture))
	bag_system.add_item(create_item("斧子", Item.ItemType.Axe, tools_texture))
	bag_system.add_item(create_item("锄头", Item.ItemType.Hoe, tools_texture))
	bag_system.add_item(create_item("喵刀", Item.ItemType.Weapon, tools_texture))
	bag_system.add_item(create_item("甜瓜种子", Item.ItemType.Placeables, tools_texture, 10))
	items = bag_system.items
	item_index = 0
	current_item = items[0] if items.size() > 0 else null

func create_item(name: String, type: Item.ItemType, texture: Texture2D, quantity: int = 1) -> Item:
	var item = Item.new()
	item.name = name
	item.type = type
	item.texture = texture
	item.quantity = quantity  # 用 quantity，修复错误
	return item

func setup_weapon() -> void:
	weapon.offset = Vector2(12, -12)
	weapon.flip_h = false
	weapon.position = Vector2(0, -12)
	jian_qi.hide()

func setup_pool() -> void:
	for i in pool_size:
		var particles = GPUParticles2D.new()
		particles.amount = 20
		particles.lifetime = 0.5
		particles.one_shot = true
		particles.emitting = false
		var mat = ParticleProcessMaterial.new()
		mat.direction = Vector3(0, -1, 0)
		mat.initial_velocity_min = 50.0
		mat.initial_velocity_max = 100.0
		mat.gravity = Vector3(100, 200, 0)
		mat.color = Color(0.2, 0.6, 1.0, 1.0)
		particles.process_material = mat
		particles.hide()
		effects_pool.add_child(particles)
		effect_pool.append(particles)

func initial() -> void:
	ground = get_tree().get_first_node_in_group("TileMap")
	raycast.target_position = Vector2(1000, 0)

func _process(delta: float) -> void:
	tool_cooldown = max(0, tool_cooldown - delta)
	update_ray()

func update_ray() -> void:
	var mouse_pos = get_global_mouse_position()
	raycast.target_position = global_position.direction_to(mouse_pos) * 1000
	raycast.force_raycast_update()
	if raycast.is_colliding() and raycast.get_collider() is TileMapLayer:
		last_direction = global_position.direction_to(raycast.get_collision_point())

func _physics_process(delta: float) -> void:
	if can_move:
		direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		if direction != Vector2.ZERO:
			last_direction = direction
			velocity = direction * speed
		else:
			velocity = velocity.move_toward(Vector2.ZERO, speed)
		move_and_slide()

	if current_item and Input.is_action_pressed("mouse_left") and tool_cooldown <= 0:
		var state = get_tool_state(current_item_type)
		if state:
			state_machine.transition_state(state)
			tool_cooldown = attack_rates.get(state, 0.4)
			attack()

func attack() -> void:
	AudioManager.play_sfx(swing_sfx)
	jian_qi.global_position = global_position
	jian_qi.show()
	var tween = create_tween()
	tween.parallel().tween_property(jian_qi, "global_position", global_position + last_direction * 200, 0.3)
	tween.tween_callback(jian_qi.hide)
	var wt = create_tween()
	wt.tween_property(weapon, "rotation_degrees", 30 if last_direction.x > 0 else -30, 0.1)
	wt.tween_property(weapon, "rotation_degrees", 0, 0.2)

func handle_selected_item(item: Item) -> void:
	if not item: return
	var coll = hit_component.get_child(0) as CollisionShape2D
	coll.shape.extents = item.collision_size if item.collision_size != Vector2.ZERO else Vector2(8, 8)

	match item.type:
		Item.ItemType.Weapon: 
			weapon.texture = item.texture
			weapon.show()
		Item.ItemType.Placeables: 
			place_component.item_to_place = item
		Item.ItemType.Consume: pass

func water() -> void:
	if raycast.is_colliding():
		var pos = raycast.get_collision_point()
		watering.emit(pos)
		show_effect(pos)

func show_effect(pos: Vector2) -> void:
	for particles in effect_pool:
		if not particles.emitting:
			particles.global_position = pos
			particles.emitting = true
			particles.restart()
			return
	var new_p = GPUParticles2D.new()
	new_p.amount = 20
	new_p.lifetime = 0.5
	new_p.one_shot = true
	new_p.emitting = true
	var mat = ParticleProcessMaterial.new()
	mat.direction = Vector3(0, -1, 0)
	mat.initial_velocity_min = 50.0
	mat.initial_velocity_max = 100.0
	mat.gravity = Vector3(100, 200, 0)
	mat.color = Color(0.2, 0.6, 1.0, 1.0)
	new_p.process_material = mat
	new_p.global_position = pos
	effects_pool.add_child(new_p)
	effect_pool.append(new_p)

func get_tool_state(type: Item.ItemType) -> String:
	match type:
		Item.ItemType.Axe: return "Axe"
		Item.ItemType.Draft: return "Draft"
		Item.ItemType.Hoe: return "Hoe"
	return ""

func _unhandled_input(event: InputEvent) -> void:
	if not current_item: return
	if event.is_action_pressed("mouse_left"):
		match current_item_type:
			Item.ItemType.Water:
				state_machine.transition_state("Water")
				water()
			Item.ItemType.Weapon:
				attack()
