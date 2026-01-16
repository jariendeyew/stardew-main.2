extends Node
class_name HoeComponent
## 主要用于放置TilemapLayer地形类物品的组件，用于锄头，地板，栅栏等需要地形连接的物品

@export var ground:TileMapLayer #用于告诉鼠标瓦片位置
@export var hoe_soil:TileMapLayer #用于放置的瓦片
@export var terrain_set: int = 0 #tilemaplayer中的地形集合

var player:Player 
var mouse_position:Vector2 #鼠标位置
var cell_position:Vector2i #tile单元格坐标
var cell_source_id:int #用于判断单元格下方是否有tile，-1则是没有
var local_cell_position:Vector2 #单元格中心位置
var distance:float

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	
func _unhandled_input(event: InputEvent) -> void:
	#print(2)
	if event.is_action_pressed("mouse_left"):
		match player.current_item_type:
			Item.ItemType.Hoe:
				get_cell_under_mouse()
				add_terrain_cell(3)
			Item.ItemType.Draft:
				get_cell_under_mouse()
				remove_terrain_cell(-1)
			Item.ItemType.Floors:
				get_cell_under_mouse()
				add_terrain_cell(0)
				


func get_cell_under_mouse() -> void:
	mouse_position = ground.get_local_mouse_position() #返回该 CanvasItem 中鼠标的位置
	cell_position = ground.local_to_map(mouse_position) #返回包含给定 mouse_position 的单元格地图坐标
	cell_source_id = ground.get_cell_source_id(cell_position) #返回位于坐标的单元格的图块源 ID。如果单元格不存在则返回 -1。
	local_cell_position = ground.map_to_local(cell_position) #返回位于坐标 coords 的单元格的图块源 ID。如果单元格不存在则返回 -1。
	distance = player.global_position.distance_to(local_cell_position) #玩家到单元格中心的距离
	
func add_terrain_cell(terrain:int)->void:
	if distance<=32 && cell_source_id != -1: #
		hoe_soil.set_cells_terrain_connect([cell_position],terrain_set,terrain,true) #更新cell_position数组的tile为terrain_set集合中的terrain地形，并忽略空地形，这个方法需要设置正确的地形过度
		
func remove_terrain_cell(terrain:int)->void:
	if distance<=32 && cell_source_id != -1:
		hoe_soil.set_cells_terrain_connect([cell_position],terrain_set,terrain,true)  #-1为空，相当于那个位置的tile置为空，而不是重新设置grass地形，那样很奇怪
