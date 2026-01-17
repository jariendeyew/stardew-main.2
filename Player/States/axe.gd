extends State

@export var player: Player
@export var anim: AnimationPlayer
@export var speed: int = 100

@onready var direction: Vector2 = Vector2.ZERO

func _enter() -> void:
	# 进入状态：淡入动画（丝滑）
	var tween = create_tween()
	tween.tween_property(anim, "modulate:a", 1.0, 0.2)  # 从透明淡入，可删
	_update_animation()

func _exit() -> void:
	anim.stop()

func _physics_update(delta: float) -> void:
	direction = player.direction
	if direction != Vector2.ZERO:
		player.last_direction = direction  # 记录方向（兼容Idle）

	_update_animation()

	if direction == Vector2.ZERO:
		transition_to.emit("Idle")
		return

	# 缓动速度（防急停）
	player.velocity = player.velocity.move_toward(direction * speed, speed * 5 * delta)
	player.move_and_slide()

func _update_animation() -> void:
	match direction:
		Vector2.UP: anim.play("move_up")
		Vector2.DOWN: anim.play("move_down")
		Vector2.LEFT: anim.play("move_left")
		Vector2.RIGHT: anim.play("move_right")
		_: anim.stop()  # 零方向停
