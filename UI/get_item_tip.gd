extends Control
## 拾取物品时的提示
@onready var nine_patch_rect: NinePatchRect = $NinePatchRect
@onready var nine_patch_rect_2: NinePatchRect = $NinePatchRect2
@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

var player:Player

func _ready() -> void:
	initial()
	#SceneManager.level_changed.connect(initial)
	
func initial() -> void:
	player = get_tree().get_first_node_in_group("Player")
	player.get_item.connect(on_get_item)
	hide()

func _process(delta: float) -> void:
	if visible:
		await get_tree().create_timer(1).timeout
		hide()
	
func on_get_item(item:Item) -> void:
	if item == null : return
	show()
	texture_rect.texture = item.texture
	label.text = item.name
