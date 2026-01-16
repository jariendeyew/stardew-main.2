extends Resource
class_name SaveData

@export var nodes:Array[PackedScene] #Placeable，Crops类作为子节点添加的物品存档
@export var player_inventory:InventorySystem
@export var box_inventory:InventorySystem #箱子应该有一个唯一标识
#还有tilemap类存档
