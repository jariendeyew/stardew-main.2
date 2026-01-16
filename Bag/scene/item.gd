extends Resource
class_name Item

enum ItemType {
	None,
	Tool,      ## 工具
	Hoe,       ## 锄头
	Axe,       ## 斧头
	Draft,     ## 稿子
	Water,     ## 水壶
	Weapon,    ## 近战武器
	Consume,   ## 消耗品
	Placeables,## 可放置物品
	Crops,     ## 作物
	Materials, ## 材料
	Accessories,## 饰品
	Floors     ## 地板
}

enum UseType {
	None,
	Swing, ## 挥舞
	Hold   ## 手持
}

enum DamageType {
	None,
	Melee,  ## 近战
	Magic,  ## 魔法
	Summon, ## 召唤
	Shoot   ## 远程
}

## 基础属性
@export_group("基础属性")
@export var name: StringName  ## 物品名
@export var type: ItemType
@export_multiline var description: String
@export var quantity: int = 1
@export var max_quantity: int = 999
@export var countable: bool = false
@export var texture: Texture2D
@export var price: int = 1

## 武器属性
@export_group("武器属性")
@export var collision_size: Vector2 = Vector2(8, 8)
@export var use_time: int = 500  ## ms
@export var use_animation: float = 1.0  ## 动画速度
@export var auto_use: bool = false
@export var damage: int = 10
@export var crit: float = 0.05  ## 5% 默认暴击
@export var knockback: float = 100.0
@export var open_trail: bool = false
@export var open_texture: bool = true
@export var use_type: UseType = UseType.Swing
@export var damage_type: DamageType = DamageType.Melee
@export var projectile: StringName  ## 投射物路径

## 放置属性
@export_group("放置属性")
@export var placeable_scene_path: String  ## e.g., "res://Scenes/placeable.tscn"

func is_max_quantity() -> bool:
	return quantity >= max_quantity

## 优化：设置武器属性（参数改名防shadowing）
func set_weapon(dmg: int, crit_rate: float, knockback_force: float) -> void:
	damage = dmg
	crit = crit_rate
	knockback = knockback_force

## 新增：显示名（支持本地化）
func get_display_name() -> String:
	return str(name).replace("_", " ")  ## e.g., "铁斧" -> "铁 斧"

## 新增：安全复制（替代duplicate()，手动调用）
func copy() -> Item:
	var new_item = duplicate()  # 用原生duplicate
	new_item.quantity = 1       # 重置数量
	return new_item
