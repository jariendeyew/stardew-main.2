extends Area2D
class_name HurtComponent


@export var tool:Item.ItemType = Item.ItemType.None #砍树所用工具
@export var max_health:int = 10 #当前物体能承受的伤害,10,5

var current_health:int = 0

signal hit_entered #工具进入hurt区域
signal hit_exited #工具退出hurt区域
#上面这两个信号主要用于处理非血量之外的特效之类的
signal body_droped #树被砍倒
signal root_droped #根被砍倒

func _ready() -> void:
	current_health = 0
	area_entered.connect(on_area_entered)
	area_exited.connect(on_area_exited)
	
func on_area_entered(area:Area2D) ->void:
	var hit = area as HitComponent
	if hit.current_item_type == tool:
		current_health+=hit.damage 
		hit_entered.emit()
		if current_health == max_health:
			body_droped.emit()
		if current_health == max_health:
			root_droped.emit()

func on_area_exited(area:Area2D) -> void:
	var hit = area as HitComponent
	if hit.current_item_type == tool:
		hit_exited.emit()
