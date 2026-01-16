extends Node2D
class_name Box

@onready var player_area_2d: Area2D = $PlayerArea2D
#@onready var click_area_2d: Area2D = $Sprite2D/ClickArea2D #这个区域必须是在sprite2D的子节点才可以检测到点击
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var box_system:InventorySystem #这里赋值的其实是单独场景编辑的时候赋值，所以后面实例化的场景都是这个资源，所以需要duplicate
@export var click_area_component: ClickAreaComponent

var body_in_area:bool

signal box_opened(name:String)#用节点名来区分所点击箱子
signal box_closed

func _ready() -> void:
	box_system.items.resize(box_system.items_size)
	box_system = box_system.duplicate() #在切换场景之后，箱子的资源还是会没有唯一化
	#原来还是场景切换没有重新连接信号导致的
	player_area_2d.body_entered.connect(on_body_entered)
	player_area_2d.body_exited.connect(on_body_exited)
	click_area_component.mouse_right_click.connect(on_mouse_right_click)
	body_in_area = false
	add_to_group("Boxes")

func on_body_entered(body:Node2D)->void:
	if body is Player:
		body_in_area = true

func on_body_exited(body:Node2D) -> void:
	if body is Player:
		body_in_area = false

func on_mouse_right_click() -> void:
	if body_in_area:
		open_the_box()
		
		
#这边脚本控制动画和开关状态相对应		
func open_the_box() -> void:
	animated_sprite_2d.play("open")
	box_opened.emit(name)
	#播放音效
	
func close_the_box(box_name:String) -> void:
	if box_name == name:
		animated_sprite_2d.play("close")
		box_closed.emit()
