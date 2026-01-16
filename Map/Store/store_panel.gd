extends Control
class_name StorePanel

const COMMODITY = preload("res://Map/Store/commodity.tscn")

@onready var v_box_container: VBoxContainer = %VBoxContainer

@export var inventorys:Array[Item] #商店的货物

func _ready() -> void:
	for child in v_box_container.get_children():
		child.queue_free()
	for i in inventorys.size():
		var commodity = COMMODITY.instantiate()
		v_box_container.add_child(commodity)
		commodity.set_item(inventorys[i])
		
