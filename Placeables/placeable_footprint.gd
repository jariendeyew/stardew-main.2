extends Area2D
class_name PlaceableFootprint

signal placement_eligibility_changed(eligible:bool) #合适放置的

var allowed_terrain:int = 224
var offending_tiles:int = 0
var placement_eligible:bool = true:#是否合适放置
	get:
		return placement_eligible
	set(val):
		placement_eligible = val
		placement_eligibility_changed.emit(val)
		
func _ready() -> void:
	area_entered.connect(on_area_entered)
	set_active(false)
	
func set_active(active:bool) -> void:
	visible = active
	
#处理碰撞
func _process_collisions() -> void:
	var colliding_area = !get_overlapping_areas().filter(
		func(area:Area2D):
			return area.get_parent() != get_parent()
	).is_empty()
	
	var colliding_tile = offending_tiles > 0
	placement_eligible = !colliding_area && !colliding_tile
	
func _process_tilemap_collision(tilemap:TileMapLayer,body_rid:RID,exited:bool) -> void:
	var collided_tile_coords = tilemap.get_coords_for_body_rid(body_rid)
	
	#for index in tilemap.get_layers_count():
		#var tile_data = tilemap.get_cell_tile_data(index,collided_tile_coords)
		#if !tile_data is TileData:
			#continue
		#var terrain_mask = tile_data.get_custom_data_by_layer_id(TerrainDetector.TerrainDataLayers.TERRAIN)
		#if (allowed_terrain & terrain_mask) ==0:
			#if exited:
				#offending_tiles -= 1
			#else:
				#offending_tiles += 1
		#break
	_process_collisions()
	
func on_area_entered(area:Area2D) ->void:
	_process_collisions()
