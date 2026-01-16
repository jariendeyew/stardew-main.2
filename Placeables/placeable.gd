extends StaticBody2D
class_name Placeable

@onready var placeable_footprint: PlaceableFootprint = $PlaceableFootprint
@onready var sprite_2d2: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var loot_table: LootTable = $LootTable

@export var placeable_item:Item

var previewing:bool: 
	set(val):
		previewing = val
		_update_shader()
var can_place:bool = true:
	set(val):
		can_place = val
		_update_shader()

func _ready() -> void:
	_update_shader()
	_populate_loot_table()

func _update_shader() -> void:
	if sprite_2d2.material == null:
		return #预览状态下不能放置是红色，可以放置是正常颜色
	sprite_2d2.material.set_shader_parameter("PREVIEW",previewing)
	sprite_2d2.material.set_shader_parameter("PLACEABLE",can_place)


func _populate_loot_table() -> void:
	#生成战利品的一系列操作
	pass

func breakdown() -> void:
	queue_free()
	#存档

func set_collision_enabled(enabled:bool) -> void:
	collision_shape_2d.set_deferred("disabled",!enabled)
