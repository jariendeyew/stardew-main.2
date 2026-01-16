extends Resource
class_name InventorySystem

signal item_changed #数组数量改变时

@export var items:Array[Item]
@export var items_size:int = 36

func swap_item(target_index:int)->void:
	var temp = MouseItem.mouse_item
	if items[target_index] and MouseItem.mouse_item and items[target_index].name == MouseItem.mouse_item.name \
	and MouseItem.mouse_item.countable:#相同物品的数量堆叠
		items[target_index].quantity += MouseItem.mouse_item.quantity
		MouseItem.mouse_item = null
	else:
		MouseItem.mouse_item = items[target_index]
		items[target_index] = temp
	item_changed.emit()

func swap_half_item(target_index:int)->void:
	
	if items[target_index] and MouseItem.mouse_item and items[target_index].name == MouseItem.mouse_item.name \
	and MouseItem.mouse_item.countable:
		items[target_index].quantity += MouseItem.mouse_item.quantity
		MouseItem.mouse_item = null
	elif items[target_index] and items[target_index].quantity > 1:
		var half_quantity = items[target_index].quantity / 2
		if items[target_index].quantity % 2 == 0:
			items[target_index].quantity = half_quantity
			MouseItem.mouse_item = items[target_index].duplicate()
		else:
			items[target_index].quantity = half_quantity
			MouseItem.mouse_item = items[target_index].duplicate()
			items[target_index].quantity += 1
			
	item_changed.emit()

func swap_one_item(target_index:int):
	if items[target_index] and items[target_index].quantity > 1:
		items[target_index].quantity -= 1
		var temp_item = items[target_index].duplicate()
		temp_item.quantity = 1
		if MouseItem.mouse_item:
			MouseItem.mouse_item.quantity += 1
		else:
			MouseItem.mouse_item = temp_item
	else:
		swap_item(target_index)
	item_changed.emit()

func remove_item(index:int)->void:
	items[index] = null
	item_changed.emit()

func remove_num_item(index:int,num:int) -> void:
	if items[index] == null: return
	if items[index].quantity > num:
		items[index].quantity -= num
	else:
		items[index] = null
	item_changed.emit()

func add_item(new_item:Item) -> void:
	if new_item == null: return 
	for item in items:
		if item and new_item.countable and new_item.name == item.name:
			item.quantity += new_item.quantity
			item_changed.emit()
			return
			#先判断是否有相同物品
	for index in items.size():
		if items[index] == null:
			items[index] = new_item
			break
		else:
			continue
	item_changed.emit()
