extends Control

@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var portaits: TextureRect = $Portaits
@onready var npc_name: Label = $NpcName

var dialogue_index = 0
var dialogue:Dialogue
var typing_tween:Tween

func _ready() -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self,"global_position",Vector2(640,720),0.5)
	await tween.finished
	dialogue_next()

func dialogue_next() -> void:
	if dialogue == null : return
	if dialogue_index >= dialogue.texts.size() : 
		var tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
		tween.tween_property(self,"global_position",Vector2(640,1120),0.3)
		await tween.finished
		queue_free()
		return
	
	var content = dialogue.texts[dialogue_index]
	
	if typing_tween and typing_tween.is_running():
		typing_tween.kill()
		rich_text_label.text = content
		dialogue_index+=1
		
	npc_name.text = dialogue.npc_name
	portaits.texture = dialogue.protaits
	rich_text_label.text = ""
	
	typing_tween = get_tree().create_tween()

	for char in content:
		typing_tween.tween_callback(func():rich_text_label.text+=char).set_delay(0.05)
	typing_tween.tween_callback(func():dialogue_index+=1)

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		dialogue_next()
