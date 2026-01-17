extends State

@export var player: Player
@export var anim: AnimationPlayer

func _enter() -> void:
	_update_animation()

func _exit() -> void:
	pass

func _physics_update(delta: float) -> void:
	if player.direction != Vector2.ZERO:
		transition_to.emit("Move")

func _update_animation() -> void:
	match player.last_direction:
		Vector2.UP: anim.play("idle_up")
		Vector2.DOWN: anim.play("idle_down")
		Vector2.LEFT: anim.play("idle_left")
		Vector2.RIGHT: anim.play("idle_right")
