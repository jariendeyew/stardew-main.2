extends State

@export var player:Player
@export var anim:AnimationPlayer
@export var tool_collistion:CollisionShape2D
@export var weapon:Sprite2D
@export var jian_qi:JianQi
@export var maker_2d:Marker2D 
#攻击状态，斜着走就会卡住出bug
#maker2d位置应该随武器贴图变化，后面再优化

func _enter():
	print("Swing")
	tool_collistion.disabled = false
	if player.current_item.open_texture:
		weapon.show()
	if player.current_item.open_trail:
			jian_qi.show()
	_update_animation()
	
func _exit():
	#基本动画和碰撞
	anim.stop()
	tool_collistion.disabled = true
	#武器
	weapon.hide()
	weapon.flip_h = false
	weapon.offset = Vector2(12,-12)
	#剑气
	jian_qi.hide()
	maker_2d.position = Vector2(16,-16)
	
	
func _physics_update(delta):
	if !anim.is_playing():
		#queue_projectile()
		if player.direction == Vector2.ZERO:
			transition_to.emit("Idle")
		else:
			transition_to.emit("Move")
	
func _update_animation():
	if player.player_direction == Vector2.UP:
		anim.play("swing_up")
		tool_collistion.position = Vector2(0,-18)
		weapon.rotation = deg_to_rad(-135)
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(weapon,"rotation",deg_to_rad(15),0.2)
	elif player.player_direction == Vector2.DOWN:
		anim.play("swing_down") #这个是逆时针，其他的是顺时针
		tool_collistion.position = Vector2(0,2)
		weapon.rotation = deg_to_rad(45) #deepseek成功回答，rotation是弧度制单位，所以必须都转换成弧度
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(weapon,"rotation",deg_to_rad(185),0.2)
	elif player.player_direction == Vector2.LEFT:
		anim.play("swing_left")
		tool_collistion.position = Vector2(-10,-12)
		weapon.flip_h = true
		weapon.offset = Vector2(-12,-12)
		weapon.rotation = deg_to_rad(35)
		maker_2d.position = Vector2(-16,-16)
		#只有左边操作时，需要额外控制属性修改
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(weapon,"rotation",deg_to_rad(-120),0.2)
	elif player.player_direction == Vector2.RIGHT:
		spawn_projectile()
		anim.play("swing_right")
		tool_collistion.position = Vector2(10,-12)
		weapon.rotation = deg_to_rad(-45)
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(weapon,"rotation",deg_to_rad(135),0.2)

var proj_ins

func spawn_projectile() -> void:
	if player.current_item.projectile == "" : return
	var proj = load(player.current_item.projectile)
	proj_ins = proj.instantiate() as Node2D
	#proj_ins.position = player.position
	player.add_child(proj_ins)#这里不能用owner，player是从场景树

func queue_projectile() -> void:
	proj_ins.queue_free()
