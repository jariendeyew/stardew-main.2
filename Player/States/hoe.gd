extends State

@export var player: Player
@export var anim: AnimationPlayer
@export var tool_collistion: CollisionShape2D

func _enter() -> void:
	tool_collistion.disabled = false
	_update_animation()

func _exit() -> void:
	anim.stop()
	tool_collistion.disabled = true

func _physics_update(delta: float) -> void:
	if not anim.is_playing():
		transition_to.emit("Idle")

func _update_animation() -> void:
	match player.last_direction:
		Vector2.UP: anim.play("hoe_up")
		Vector2.DOWN: anim.play("hoe_down")
		Vector2.LEFT: anim.play("hoe_left")
		Vector2.RIGHT: anim.play("hoe_right")
