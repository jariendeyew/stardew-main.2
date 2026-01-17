extends State

@export var player: Player
@export var anim: AnimationPlayer
@export var tool_collistion: CollisionShape2D

@onready var delay_timer: Timer = $DelayTimer  # 新：加 Timer 子节点到 water.tscn

func _enter() -> void:
	tool_collistion.disabled = true
	anim.speed_scale = 0.5
	_update_animation()
	await get_tree().create_timer(20 / Engine.physics_ticks_per_second).timeout  # 延时，等动画帧
	tool_collistion.disabled = false

func _exit() -> void:
	anim.stop()
	tool_collistion.disabled = true
	anim.speed_scale = 1

func _physics_update(delta: float) -> void:
	if not anim.is_playing():
		transition_to.emit("Idle")

func _update_animation() -> void:
	match player.last_direction:
		Vector2.UP: 
			anim.play("water_up")
			tool_collistion.position = Vector2(0, -18)
		Vector2.DOWN: 
			anim.play("water_down")
			tool_collistion.position = Vector2(0, 2)
		Vector2.LEFT: 
			anim.play("water_left")
			tool_collistion.position = Vector2(-10, -12)
		Vector2.RIGHT: 
			anim.play("water_right")
			tool_collistion.position = Vector2(10, -12)
