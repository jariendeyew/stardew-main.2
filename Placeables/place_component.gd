# place_component.gd
extends Node
class_name PlaceComponent          # 与文件名保持一致

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  放置配置
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
@export var item_to_place: Item    # 外部把要放的道具塞进来

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  信号
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
signal placed(item: Item, global_pos: Vector2)   # 通知外部“我放好了”

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  公开接口：尝试在指定坐标放置
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
func try_place(global_pos: Vector2) -> bool:
	if not item_to_place or item_to_place.quantity <= 0:
		return false

	# 可以在这里加地形/碰撞检测，通过再真正放置
	emit_signal("placed", item_to_place, global_pos)

	# 扣数量
	item_to_place.quantity -= 1
	if item_to_place.quantity <= 0:
		item_to_place = null
	return true
