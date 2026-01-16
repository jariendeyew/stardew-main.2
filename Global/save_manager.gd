extends Node
## Autoload
## 从save_component获取需要存档的数据
## 然后用save_data封装数据，最后在用此脚本写到硬盘中

func _save() -> void:
	var save_data = SaveData.new()
	#nodes
	var save_components = get_tree().get_nodes_in_group("SaveComponents") as Array[SaveComponent]
	for save_component in save_components: #到myhouse的时候save_component会被释放掉
		save_data.nodes = save_component.get_save_data()
	#player_inventory
	var player = get_tree().get_first_node_in_group("Player") as Player
	save_data.player_inventory = player.bag_system
	#box_inventory
	ResourceSaver.save(save_data,"user://abc.tres")
	
func _load() -> void:
	var save_data = ResourceLoader.load("user://abc.tres") as SaveData
	#nodes
	var save_components = get_tree().get_nodes_in_group("SaveComponents") as Array[SaveComponent]
	for save_component in save_components:
		print(save_data.nodes)
		save_component.set_save_data(save_data.nodes)
	#player_inventory
	var player = get_tree().get_first_node_in_group("Player") as Player
	player.bag_system = save_data.player_inventory
