extends State

@export var player:Player
@export var anim:AnimationPlayer


func _enter():
	print("Idle")
	anim.play("idle_down")
	#anim["parameters/Idle/blend_position"] = Vector2.DOWN
	
	
func _exit():
	pass# 离开这个状态时要做什么
	
func _physics_update(delta):
	_update_animation()
		
	if player.direction != Vector2.ZERO:
		transition_to.emit("Move")
	
	
func _update_animation():
	if player.player_direction == Vector2.UP:
		anim.play("idle_up")
	elif player.player_direction == Vector2.DOWN:
		anim.play("idle_down")
	elif player.player_direction == Vector2.LEFT:
		anim.play("idle_left")
	elif player.player_direction == Vector2.RIGHT:
		anim.play("idle_right")
	#anim["parameters/Idle/blend_position"] = player.player_direction

#func _unhandled_input(event: InputEvent) -> void: #这个函数可以忽略UI的事件操作
	##可以使用信号转换，也可以使用函数转换
	#if event.is_action_pressed("mouse_left"):
		#match player.current_item_type:
			#Item.ItemType.Axe:
				#transition_to.emit("Axe")
			#Item.ItemType.Draft:
				#transition_to.emit("Draft")
			#Item.ItemType.Hoe:
				#transition_to.emit("Hoe")
			#Item.ItemType.Water:
				#transition_to.emit("Water")
			#Item.ItemType.Weapon:
				#transition_to.emit("Swing")
			#_:
				#print("没有对应类型")
