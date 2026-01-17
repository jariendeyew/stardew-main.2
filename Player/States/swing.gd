extends State

@export var player: Player
@export var anim: AnimationPlayer
@export var tool_collistion: CollisionShape2D
@export var weapon: Sprite2D
@export var jian_qi: JianQi
@export var maker_2d: Marker2D

func _enter() -> void:
	tool_collistion.disabled = false
	if player.current_item.open_texture:
		weapon.show()
	if player.current_item.open_trail:
		jian_qi.show()
	_update_animation()

func _exit() -> void:
	anim.stop()
	tool_collistion.disabled = true
	weapon.hide()
	weapon.flip_h = false
	weapon.offset = Vector2(12, -12)
	jian_qi.hide()
	maker_2d.position = Vector2(16, -16)

func _physics_update(delta: float) -> void:
	if not anim.is_playing():
		if player.direction == Vector2.ZERO:
			transition_to.emit("Idle")
		else:
			transition_to.emit("Move")

func _update_animation() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	match player.last_direction:
		Vector2.UP:
			anim.play("swing_up")
			tool_collistion.position = Vector2(0, -18)
			weapon.rotation = deg_to_rad(-135)
			tween.tween_property(weapon, "rotation", deg_to_rad(15), 0.2)
		Vector2.DOWN:
			anim.play("swing_down")
			tool_collistion.position = Vector2(0, 2)
			weapon.rotation = deg_to_rad(45)
			tween.tween_property(weapon, "rotation", deg_to_rad(185), 0.2)
		Vector2.LEFT:
			anim.play("swing_left")
			tool_collistion.position = Vector2(-10, -12)
			weapon.flip_h = true
			weapon.offset = Vector2(-12, -12)
			weapon.rotation = deg_to_rad(35)
			maker_2d.position = Vector2(-16, -16)
			tween.tween_property(weapon, "rotation", deg_to_rad(-120), 0.2)
		Vector2.RIGHT:
			anim.play("swing_right")
			tool_collistion.position = Vector2(10, -12)
			weapon.rotation = deg_to_rad(-45)
			tween.tween_property(weapon, "rotation", deg_to_rad(135), 0.2)
	spawn_projectile()

func spawn_projectile() -> void:
	if player.current_item.projectile == "": return
	var proj_scene = load(player.current_item.projectile) as PackedScene  # 移_ready preload更好
	var proj_ins = proj_scene.instantiate() as Node2D
	player.add_child(proj_ins)
