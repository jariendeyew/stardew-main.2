extends State

@export var player: Player
@export var anim: AnimationPlayer
# 移除本地 speed，用 player.speed 统一（防冲突）

var direction: Vector2 = Vector2.ZERO

func _enter() -> void:
	pass

func _exit() -> void:
	anim.stop()

func _physics_update(delta: float) -> void:
	direction = player.direction
	if direction != Vector2.ZERO:
		player.last_direction = direction
	_update_animation()
	if direction == Vector2.ZERO:
		transition_to.emit("Idle")
		return
	# 用 player.speed（Inspector 调100正常）
	player.velocity = direction * player.speed
	player.move_and_slide()

func _update_animation() -> void:
	match direction:
		Vector2.UP: anim.play("move_up")
		Vector2.DOWN: anim.play("move_down")
		Vector2.LEFT: anim.play("move_left")
		Vector2.RIGHT: anim.play("move_right")
